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

    QList<QObject*> facilityCategories;
    auto categoriesJsn = jsn["types"].toObject();
    for(auto category : categoriesJsn.keys() ){
        auto parameters = categoriesJsn[category].toObject()["param"].toObject().keys();
        if(parameters.count() == 0)
            continue;
        auto categoryO = new DeviceCategory(category, rootParent);
        facilityCategories.append(categoryO);
        for(auto paremeter : parameters)
            categoryO->addParameter(paremeter);
    }

    return facilityCategories;


    /// вызов происходит из .qml-файла (P.S. я не знаю, зачем из .qml а не из .cpp)
//    void BuildingInfoProvider::parseBuildings( const QJsonObject &jsn )
//    {
//        /// \detailed считывание всех групп зданий
//        _idsForGroups = parseGroups( jsn["groups"].toObject() );
//        _idsForGroups.insert( 0, Group( "Все здания" ) );
//        _idsForGroups.insert( 1, Group( "Датчики здания" ) );
//
//        QMap<int, BuildingsModel *> groupsForBuildings;
//        for ( int gid : _idsForGroups.keys() )
//            groupsForBuildings.insert( gid, new BuildingsModel( nullptr ) );
//
//        /// \detailed считывание всех зданий
//        auto bldsJsn = jsn["buildings"].toObject();
//        for ( const QString &bldId : bldsJsn.keys() )
//        {
//            auto bldJsn = bldsJsn[bldId].toObject();
//            bldJsn.insert( "id", bldId );
//
//    #if DEBUG_BUILDINGS
//            if ( ( bldJsn["id"] != off /*|| id == NV_x_StZg*/ ) ) // if (! ...
//                continue;
//    #endif
//
//            /// исключаем одинаковые здания (хотя мне кажется их приходить с сервера не должно, так что сомнительная мера)
//            if ( !bldJsn.contains( "name" ) || m_buildings.contains( bldId ) )
//                continue;
//            m_buildings.insert( bldId, nullptr );
//
//            // todo мб в отдельную ф-ю
//            // парсим здание на факт принадлежности к группам
//            auto grpsIdsJsn = bldJsn["groups"].toArray();
//            QJsonObject areasJsn = jsn["osmAreas"].toObject();
//
//            /// в группу Все Здания добавляется каждое здание. Причем с поддержанием иерархической структуры - только для
//            /// 0-й группы всех зданий парсим здание на факт принадлежности к территориям, внутри дополняется модель
//            /// groupsForBuildingsMdl[grpId]
//            BuildingItem *newAllBuildingsParent = parseBldHierarcy( groupsForBuildings[0], bldJsn, areasJsn, false );
//
//            /// добрались до здания. Для каждого полученного здание - 1 и только 1 объект BuildingInfo должен быть создан
//            BuildingInfo *buildingInfo = new BuildingInfo( bldJsn, EAObjectType::OtPlanPart, newAllBuildingsParent );
//            connect( buildingInfo, &BuildingInfo::getBuildingsDetails, this,
//                     [this, buildingInfo]() { emit fetchBuildingsDetails( buildingInfo ); } );
//            newAllBuildingsParent->createChild( buildingInfo, "building" );
//            m_buildings[bldId] =
//                buildingInfo; // m_buildings - это дублирование уже имеющихся в модели данных для удобства доступа
//
//            for ( auto grpIdJsn : grpsIdsJsn )
//            {
//                int grpId = grpIdJsn.toInt();
//
//                /// самое главное происходит здесь!
//                if ( groupsForBuildings.contains( grpId ) )
//                {
//                    /// значит здание ссылается на существующую группу
//                    BuildingItem *newBldParent = parseBldHierarcy( groupsForBuildings[grpId], bldJsn,
//                                                                   areasJsn ); // узел, который будет стоять перед зданием
//                    /// добрались до самого здания
//                    newBldParent->createChild( buildingInfo, "building" );
//                }
//            }
//        }
//
//        /// \detailed раскладывание моделей зданий для групп по этим группам
//        for ( auto grpId : _idsForGroups.keys() )
//            _idsForGroups[grpId].buildingsModel = new BuildingsProxyModel( this, groupsForBuildings[grpId] );
//
//        /// \detailed создание модели для qml-списка Групп (а уже одной Группе в свою очередь будет соответствовать одна
//        /// модель зданий)
//        _groupsModel = new GroupsModel( _idsForGroups.values(), this );
//        emit groupsModelChanged();
//    }
//
//    QMap<int, Group> BuildingInfoProvider::parseGroups( const QJsonObject &grpsJsn )
//    {
//        QMap<int, Group> grps;
//        for ( const QString &grpId : grpsJsn.keys() )
//        {
//            auto grpJsn = grpsJsn[grpId].toObject();
//            if ( !grpJsn.contains( "description" ) )
//                continue;
//            int id = grpId.toInt();
//            if ( !grps.contains( id ) )
//                grps.insert( id, Group( grpJsn ) );
//        }
//
//        return grps;
//    }

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
    view.setSource(QUrl("../WidgetsEditor/WidgetsEditor.qml"));
    if (view.status() == QQuickView::Error)
        return -1;
    view.setResizeMode(QQuickView::SizeRootObjectToView);
    QQmlContext *ctxt = view.rootContext();
    ctxt->setContextProperty("facilityCategoriesModel", QVariant::fromValue(facilityCategories));
    view.show();

 //   auto o = new OutputAcceptor(&app);
//    QObject *item = dynamic_cast<QObject*>(view.rootObject());
//    QObject::connect(o, SIGNAL(widgetChanged(const QJsonObject&)), o, SLOT(onWidgetChanged(const QJsonObject&)));

    return app.exec();
}
