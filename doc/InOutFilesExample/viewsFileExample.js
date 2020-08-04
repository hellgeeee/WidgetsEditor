// Отображение персональных виджетов.
// Сюда добавляем пару "Имя файла" - список типов.
var personal = {
    "ipcamera" : [ 'IpVideoCamera', 'IpPTZVideoCamera', 'DynamicVideoCamera' ]
    , "garbageZone" : [ 'GarbageZone' ]
    , "garbageContainer" : [ 'GarbageContainer' ]
    , "computer_view" : [ 'Computer', 'Server' ]
    , "switch_view" : ["EthernetSwitch", "ZWaveRelaySwitch"]
    , "ttk_notifier" : ['TtkNotificationsClient','TtkAppearTv']
    , "observerPoint" : ['ObservablePoint']
    , "intercom_terminal" : ['IntercomTerminal']
    , "emergency_terminal" : ["EmergencyCallPoint"]
    , "intercom_controller" : ['IntercomController']
    , "env_sensor" : [ 'Msu24', 'Hs_rs485']
    , "access_device" : ['Lock', 'Turnstile']
    , "amperage" : ['AmperageSensor_DTA_42050']
    , "flowmeter" : ['Water_flowmeter_BCXd_20', 'Watersupply_flowmeter']
    , "thermometr" : ['Watersupply_thermometr']
    , "termoconverter" : ['Water_termoconverter_ktsp_N']
    , "manometr" : ['Water_manometr_PDTVX1', 'Watersupply_manometr']
    , "valve" : ['Water_valve_engine_Belimo_LR24A_SR']
    , "fire_notify" : ['FireBell','FireSiren','Payphone','NoBonfireSign','WaterIntakeSign','FireTank']
    , "bullhorn" : ["Bullhorn"]
    , "fireSiren" : ["FireSiren"]
    , "satchelExtinguisher" : ["SatchelExtinguisher"]
    , "countryMarker" : ["CountryMarker"]
    , "davis_full" : ['MeteoStationDavisPro','MeteoStationRosgidromet', 'MeteoStationM49M','MeteoStationIws', 'MeteoStationMK15', 'MeteoStationVaisala']
    , "ask_full" : ['AskAtmosferaChemicalSensor']
    , "atmsensor_view" : ['AtmSensor']
    , "sprut_view" :['ThermalSensorSprutM', 'ThermalSystemSprutM']
    , "sprutsystem_view" : ['ThermalSystemSprutM']
    , "incramSensor" : ['IncramSensor']
    , "ttk_notifier" : ['TtkNotificationsClient','TtkAppearTv']
    , "fire_hydrant" : ['Fire_hydrant']
    , "wells" :  ['SecureSensorPrepona']
    , "integra_kdd" : ['IntegraKDDsensor']
    , "disel_generator" : ['DieselGenerator']
    , "bascule_barrier" : ['Bascule_barrier']
    , "human" : [ 'Male', 'Female', 'Paramedic', 'IncidentMarker' ]
    , "GlonassRoadEvent" : ['EraGlonassRoadEvent']
    , "incident_view" : ['IncidentEvent']
    , "ip_speedcam" : ['IpSpeedCam']
    , "interstate_object" : ['VehicleWeightControl','CustomsPost']
    , "policeCar" : ['Policecar', 'PassengerCar']
    , "ipvideocamera" : ['IpVideoCamera']
    , "hazard_view" : ['HazardStorageGas']
    , "water_temp_sensor" : ['WaterTemperatureSensor']
    , "bus" : ['Car']
    , "ups_device" :['UPS_smart', 'UPS_SIPB6KD']
    , "shipping_mark" : ['Shipping_mark']
    , "ship_target" : ["SeaTarget"]
    , "sibintek_view" : ['SibintekBoolSensor',
                            'SibintekControlOpenSensor',
                            'SibintekControlVibrationSensor',
                            'SibintekCurrentSensor',
                            'SibintekEngine',
                            'SibintekFlowDigitalSensor',
                            'SibintekFlowSensor',
                            'SibintekHeater',
                            'SibintekLevelDigitalSensor',
                            'SibintekLevelSensor',
                            'SibintekPressureSensor',
                            'SibintekTemperatureSensor',
                            'SibintekValve']

    , "lers_view" : ['LersMeasurePoint',
                        'LersObject',
                        'LersServer']

    , "tempaccomoda" : ['TemporaryAccomodation']
    , "radshelter" : ['AntiradiationShelter','NightStayAccomodation','ProtectiveBuilding']


    , "rs485unit20_view" : ["Rs485Unit20"]
    , "firesensor_view" : ["LowCurrentFireSensor"]
    , "bolidsensors_view" : ["BOLID_VolumeSensor",
                                "BOLID_FireSensor",
                                "BolidPult",
                                "BOLID_ContactSensor"]
    , "powerdistributor_view" : ["PowerDistributor"]
    , "RadioRelayStationMIK_RL_view" : ["RadioRelayStationMIK_RL"]
    , "roadwayZone" : ["RoadwayZone"]
    , "network_switch_view" : ["ES3124"]



    //--- emercit sensors ---
    , "EmercitWaterLevel" : [ "EmercitWaterLevelSensor", "EmercitWaterMeasuringStation" ]
    , "EmercitPrecipitation" : [ "EmercitPrecipitationSensor" ]
    , "EmercitPrecipitationIntensity" : [ "EmercitPrecipitationIntensitySensor" ]
    , "EmercitAirTemperature" : [ "EmercitAirTemperatureSensor" ]
    , "EmercitAirHumidity" : [ "EmercitAirHumiditySensor" ]
    , "EmercitDewPoint" : [ "EmercitDewPointSensor" ]
    , "EmercitAirPressureAbs" : [ "EmercitAirPressureAbsSensor" ]
    , "EmercitAirPressureRel" : [ "EmercitAirPressureRelSensor" ]
    , "EmercitEquivalentDoseRate" : [ "EmercitEquivalentDoseRateSensor" ]
    , "EmerciGasConcentration" : [ "EmerciGasConcentrationSensor" ]
    , "AvangardCO" : ["AvangardCOSensor"]
    , "CO2MonitorDadget" : ["CO2MonitorDadget"]
    , "natex_nx_x" : ["Natex_NX_3424","Cisco_Catalyst_3650_48PS"]
    , "radar_view" : ["Radar"]
    , "water_tower" : ["WaterTower"]
    , "radioRelayStationYPacket" : ["RadioRelayStationYPacket"]
    , "compositeMeteostation" : ["CompositeMeteostationStation"]
    , "xiaomiTemperatureSensor" : ["AisCityItemXiaomiTemperatureSensor"]
    , "sirenView" : ["LowCurrentSirenMeta"]
    , "spaceView" : ["Space"]
}
