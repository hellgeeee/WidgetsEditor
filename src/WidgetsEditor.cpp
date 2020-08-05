#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlFileSelector>
#include <QQuickView>
#include <QQmlContext>
#include <QObject>
#include "WidgetsEditor.h"
#include <QJsonDocument>
#include <QMessageBox>

#include <QJsonArray>

#include<QDebug>

QList<QObject*> WidgetsEditorManager::parse()
{
    /// 1. Считать те категории устройств, для которых виджеты уже существуют
    QDir IPEFolder = QDir(_IPEFolder);
    IPEFolder.cd("../../qml/SensorView/scripts");

    QFile file(IPEFolder.path() + "/views.js");
    if(!file.open(QIODevice::ReadOnly | QIODevice::Text))
        return QList<QObject*>();
    QString str = QString(file.readAll());
    file.close();

    QSet<QString> existingWidgetsCategories;
    if(str != ""){
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

        _existingWidgetsJsn = QJsonDocument::fromJson(str.toUtf8()).object();

        for(auto widgetName : _existingWidgetsJsn.keys())
            for(auto category : _existingWidgetsJsn[widgetName].toArray() )
                existingWidgetsCategories.insert(category.toString());
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

void WidgetsEditorManager::setInFileName(const QString& val){
    _inFileName = val;
    _categories = parse();
}

void WidgetsEditorManager::setOutFileName(const QString& val){

    QDir IPEFolder = QDir(_IPEFolder);
    IPEFolder.cd("../../qml/SensorView/templates");
    _outFileName = IPEFolder.path() + "/" + val + ".qml";

    QFile file(_outFileName);
    if (!file.open(QIODevice::ReadWrite | QIODevice::Text)){
        qDebug()<< "file wasn't open! Sos! Do something with this pls.";
        return;
    }
    QTextStream in(&file);
    _outFileContent = in.readAll();
    file.close();
}

void WidgetsEditorManager::setOutFileContent(const QString& val){

   /// формируем путь к файлу вывода
   QFile file(_outFileName);

   if (!file.open(QIODevice::WriteOnly | QIODevice::Text)){
       qDebug()<< "file wasn't open! Sos! Do something with this pls.";
       return;
   }
   QTextStream out(&file);
   out << "ComplexWidget" << val;
   file.close();
}

void WidgetsEditorManager::setSelectedCategories(const QString& newWidgetCategories){

    /// 1. объединить существующую карту по виджетам и категориям
    QJsonValue newWidgetCategoriesJsn =  QJsonDocument::fromJson(newWidgetCategories.toUtf8()).object();
    QJsonArray allWidgetsCategoriesJsn;
    allWidgetsCategoriesJsn.append(_existingWidgetsJsn);
    allWidgetsCategoriesJsn.append(newWidgetCategoriesJsn);
    QString allWidgetsCategories(QJsonDocument(allWidgetsCategoriesJsn).toJson());

    /// избавиться от квадратных кавычек и добавить строку впереди, чтобы как было изначально
    allWidgetsCategories = "var personal =" + allWidgetsCategories.mid(2, allWidgetsCategories.length() - 4);

    /// 2. записать объединение в файл
    QDir IPEFolder = QDir(_IPEFolder);
    IPEFolder.cd("../../qml/SensorView/scripts");
    QFile file(IPEFolder.path() + "/views.js");

    if (!file.open(QIODevice::WriteOnly | QIODevice::Text)){
        qDebug()<< "file wasn't open! Sos! Do something with this pls.";
        return;
    }
    QTextStream out(&file);
    out << allWidgetsCategories;
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
