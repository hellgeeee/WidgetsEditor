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
#include <QRegularExpression>

QList<QObject*> WidgetsEditorManager::parse()
{
    /// 1. Считать те категории устройств, для которых виджеты уже существуют
    QDir IPEFolder = QDir(_IPEFolder);
    IPEFolder.cd("qml/SensorView/scripts");

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
    qDebug() << _inFileName;
    if(!file.open(QIODevice::ReadOnly | QIODevice::Text)){
        qDebug()<< "file " + _inFileName + " wasn't open! Sos! Do something with this pls.";
        return QList<QObject*>();
    }
    QJsonObject jsn = QJsonDocument::fromJson(QString(file.readAll()).toUtf8()).object();
    file.close();

    QList<QObject*> deviceCategories;
    auto categoriesJsn = jsn["types"].toObject();
    for(QString category : categoriesJsn.keys() ){

        /// не берем данную категорию устройств, если для нее хоть что-то из перечисленного выполнилось:
        /// - нет параметров
        /// - уже есть виджет,
        /// - она содержат аттрибут "abstract": "true"
        /// - наследованиях типа нет типа "SpatialObject" или  "MoveableObject"
        auto attrs = categoriesJsn[category].toObject()["attributes"].toObject();
        bool isAbstract = attrs.keys().contains("abstract") && attrs["abstract"] == "true";

        auto heritages = categoriesJsn[category].toObject()["is"].toArray();
        bool isPropperHeritage = false;
        for(auto heritage : heritages)
            if(heritage == "SpatialObject" || heritage == "MoveableObject"){
                isPropperHeritage = true;
                break;
            }
        auto parameters = categoriesJsn[category].toObject()["param"].toObject().keys();

        /// 3. Запомнить каждую категорию (по имени), если подходит вместе со всеми ее параметрами
        if(parameters.count() == 0 || existingWidgetsCategories.contains(category) || isAbstract || !isPropperHeritage)
            continue;
        QString categoryImage = categoriesJsn[category].toObject()["attributes"].toObject()["image"].toString();
        if(categoryImage != "" && !QFile(_IPEFolder + "/build_editor/Release_x64/media/sensors/" + categoryImage).exists())
            categoryImage = "";
        auto categoryO = new DeviceCategory(category, categoryImage, this);
        deviceCategories.append(categoryO);
        for(auto paremeter : parameters)
            categoryO->addParameter(paremeter);
    }
    return deviceCategories;
}

DeviceCategory::DeviceCategory(const QString& name, const QString& image, QObject* parent) : QObject(parent) {
    _name = name;
    _image = image;
}

void WidgetsEditorManager::setInFileName(const QString& val){
    _inFileName = val;
    _categories = parse();
}

void WidgetsEditorManager::setOutFileName(const QString& val){

    QDir IPEFolder = QDir(_IPEFolder);
    IPEFolder.cd("qml/SensorView/templates");
    _outFileName = IPEFolder.path() + "/" + val + ".qml";

    QFile file(_outFileName);
    if (!file.open(QIODevice::ReadOnly | QIODevice::Text)){
        /// значит, не существует
        qDebug() << "file you try to open does not exist";
        //qDebug()<< "file wasn't open! Sos! Do something with this pls.";
        return;
    }
    QTextStream in(&file);
    _outFileContent = in.readAll();
    file.close();
}

void WidgetsEditorManager::setOutFileContent(const QString& contentJsonFormated){

    QString contentJsFormated = contentJsonFormated;

   /// число в любых кавычках и следующее за ним двоеточие после любого количества пробелов и табуляций и новых строк
   QRegularExpression re("(\"|\')(\\d+)(\"|\')([ \t\n]*:)");
   QRegularExpressionMatch match = re.match(contentJsFormated);
   while (match.hasMatch()) {
       contentJsFormated.replace(match.captured(1)+ match.captured(2) + match.captured(3), match.captured(2));
       match = re.match(contentJsFormated);
   }
   contentJsFormated.replace("\"text_params\"", "text_params");
   contentJsFormated.replace("\"analog_params\"", "analog_params");
   contentJsFormated.replace("\"param_icons\"", "param_icons");

   /// формируем путь к файлу вывода
   QFile file(_outFileName);
   if (!file.open(QIODevice::WriteOnly | QIODevice::Text)){
       qDebug()<< "file wasn't open! Sos! Do something with this pls.";
       return;
   }
   QTextStream out(&file);
   out << "import QtQuick 2.0\nimport \"../../Components\"\n\nComplexWidget" << contentJsFormated;
   file.close();
}

void WidgetsEditorManager::setSelectedCategories(const QString& newWidgetCategories){

    /// 1. объединить существующую карту по виджетам и категориям
    QJsonValue newWidgetCategoriesJsn =  QJsonDocument::fromJson(newWidgetCategories.toUtf8()).object();
    QJsonArray allWidgetsCategoriesJsn;
    allWidgetsCategoriesJsn.append(_existingWidgetsJsn);
    allWidgetsCategoriesJsn.append(newWidgetCategoriesJsn);
    QString allWidgetsCategories(QJsonDocument(allWidgetsCategoriesJsn).toJson());

    /// избавиться от пары лишних фигурных скобок "},{" в результате слияния 2-х json-объектов
    QRegularExpression re("([ \t\n]*},[ \t\n]*{[ \t\n]*)");
    QRegularExpressionMatch match = re.match(allWidgetsCategories);
    if(match.hasMatch())
        allWidgetsCategories.replace(match.captured(), ",\n");

    /// избавиться от квадратных кавычек и добавить строку впереди, чтобы как было изначально
    allWidgetsCategories = "var personal =" + allWidgetsCategories.mid(2, allWidgetsCategories.length() - 4);

    /// 2. записать объединение в файл
    QDir IPEFolder = QDir(_IPEFolder);
    IPEFolder.cd("qml/SensorView/scripts");
    QFile file(IPEFolder.path() + "/views.js");

    if (!file.open(QIODevice::WriteOnly | QIODevice::Text)){
        qDebug()<< "file wasn't open! Sos! Do something with this pls.";
        return;
    }
    QTextStream out(&file);
    out << allWidgetsCategories;
    file.close();
}

void WidgetsEditorManager::setLanguage(const QString language){
    _translator->load("main_en", "." ); // todo
    qApp->installTranslator(_translator);
qDebug() << "trans installed";
    _language = language;
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
