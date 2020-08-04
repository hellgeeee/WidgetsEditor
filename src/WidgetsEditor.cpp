#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlFileSelector>
#include <QQuickView>
#include <QQmlContext>
#include <QObject>
#include "WidgetsEditor.h"
#include <QJsonDocument>
#include <QJsonObject>

#include <QJsonArray>

#include<QDebug>

QList<QObject*> WidgetsEditorManager::parse()
{
    /// 1. Считать те категории устройств, для которых виджеты уже существуют
    QFile file(_widgetsExistFileName);
    QSet<QString> existingWidgetsCategories;

    if(_widgetsExistFileName != ""){
        if(!file.open(QIODevice::ReadOnly | QIODevice::Text))
            return QList<QObject*>();
        QString str = QString(file.readAll());
        file.close();

        /// избавляемся от "var personal = "
        str = str.replace(0, str.indexOf("{"), "");

        /// а также от комментария
        int commentPlace = str.indexOf("//");
        int commentLength = str.indexOf(",",commentPlace) - commentPlace;
        str = str.replace(commentPlace, commentLength, "");

        /// заменяем одинарные кавычки на двойные (P.S. TODO нельзя ли сделать формат файла чуть аккуратнее?)
        int wrongBraceInd = 0;
        while(wrongBraceInd >= 0){
            wrongBraceInd = str.indexOf("'");
            str = str.replace(wrongBraceInd, 1, "\"");
        }

        QJsonObject jsn = QJsonDocument::fromJson(str.toUtf8()).object();

        for(auto widgetName : jsn.keys())
        for(auto category : jsn[widgetName].toArray() ){
            existingWidgetsCategories.insert(category.toString());
        }
    }

    /// 2. Считать категории устройств, доступных для участия в создании виджетов
    file.setFileName(_inFileName);
    if(!file.open(QIODevice::ReadOnly | QIODevice::Text))
        return QList<QObject*>();
    QJsonObject jsn = QJsonDocument::fromJson(QString(file.readAll()).toUtf8()).object();
    file.close();

    QList<QObject*> deviceCategories;
    auto categoriesJsn = jsn["types"].toObject();
    for(auto category : categoriesJsn.keys() ){
        auto parameters = categoriesJsn[category].toObject()["param"].toObject().keys();
        if(parameters.count() == 0 || existingWidgetsCategories.contains(category))
            continue;
        auto categoryO = new DeviceCategory(category, this);
        deviceCategories.append(categoryO);
        for(auto paremeter : parameters)
            categoryO->addParameter(paremeter);
    }
    return deviceCategories;
}

DeviceCategory::DeviceCategory(const QString& name, QObject* parent) : QObject(parent) {
    _name = name;
}

void WidgetsEditorManager::setCategories(QList<QObject*> val){
    _categories = val;
}

void WidgetsEditorManager::setOutFileContent(const QString& val){
   QFile file(_outFileName);
   if (!file.open(QIODevice::WriteOnly | QIODevice::Text)){
       qDebug()<< "file wasn't open! Sos! Do something with this pls.";
       return;
   }
   QTextStream out(&file);
   out << val;
   file.close();
}


int main(int argc, char *argv[])
{
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
    QCoreApplication::setOrganizationName("Integra-s");
    QGuiApplication app(argc, argv);

    WidgetsEditorManager* widgetsEditorManager = new WidgetsEditorManager(&app);
    QQuickView view;
    view.connect(view.engine(), &QQmlEngine::quit, &app, &QCoreApplication::quit);
    view.setSource(QUrl("qrc:/WidgetsEditor.qml"));
    if (view.status() == QQuickView::Error)
        return -1;
    view.setResizeMode(QQuickView::SizeRootObjectToView);
    QQmlContext *ctxt = view.rootContext();
    ctxt->setContextProperty("widgetsEditorManager", QVariant::fromValue(widgetsEditorManager));
    view.show();

    return app.exec();
}
