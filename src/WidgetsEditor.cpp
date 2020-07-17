#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlFileSelector>
#include <QQuickView>
#include <QQmlContext>
#include <QObject>
#include "WidgetsEditor.h"
#include <QJsonDocument>
#include <QJsonObject>
 #include<QDebug>

QList<QObject*> parse(const QString& fileName, QObject* rootParent)
{
    QFile file;

    file.setFileName(fileName);
    file.open(QIODevice::ReadOnly | QIODevice::Text);
    QJsonObject jsn = QJsonDocument::fromJson(QString(file.readAll()).toUtf8()).object();
    file.close();

    QList<QObject*> deviceCategories;
    auto categoriesJsn = jsn["types"].toObject();
    for(auto category : categoriesJsn.keys() ){
        auto parameters = categoriesJsn[category].toObject()["param"].toObject().keys();
        if(parameters.count() == 0)
            continue;
        auto categoryO = new DeviceCategory(category, rootParent);
        deviceCategories.append(categoryO);
        for(auto paremeter : parameters)
            categoryO->addParameter(paremeter);
    }

    return deviceCategories;

}

DeviceCategory::DeviceCategory( const QString& name, QObject* parent) : QObject(parent) {
    _name = name;
}

void OutputAcceptor::onWidgetChanged(const QJsonObject&){
    qDebug()<<"Got in slot";
}

int main(int argc, char *argv[])
{
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
    QCoreApplication::setOrganizationName("Integra-s");
    QGuiApplication app(argc, argv);

    QList<QObject*> facilityCategories = parse("../test/userFolder/test.json", &app);
    // for debug
//    QList<QObject*> facilityCategories0;
//    facilityCategories0.append(new FacilityCategory("red"));
//    facilityCategories0.append(new FacilityCategory("green"));
//    facilityCategories0.append(new FacilityCategory("blue"));
//    facilityCategories0.append(new FacilityCategory("yellow"));

    QQuickView view;
    view.connect(view.engine(), &QQmlEngine::quit, &app, &QCoreApplication::quit);
    view.setSource(QUrl("../src/WidgetsEditor.qml"));
    if (view.status() == QQuickView::Error)
        return -1;
    view.setResizeMode(QQuickView::SizeRootObjectToView);
    QQmlContext *ctxt = view.rootContext();
    ctxt->setContextProperty("deviceCategoriesModel", QVariant::fromValue(facilityCategories));
    view.show();

 //   auto o = new OutputAcceptor(&app);
//    QObject *item = dynamic_cast<QObject*>(view.rootObject());
//    QObject::connect(o, SIGNAL(widgetChanged(const QJsonObject&)), o, SLOT(onWidgetChanged(const QJsonObject&)));

    return app.exec();
}
