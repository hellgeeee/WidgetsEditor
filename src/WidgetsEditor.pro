TEMPLATE += app

QT += quick widgets multimedia

CONFIG += c++11 qtquickcompiler warn_on # хотя не знаю, влияет ли warn_on хоть на что-то, надеюсь больше предупреждений

DEFINES += QT_DEPRECATED_WARNINGS


SOURCES += \
    *.cpp \

HEADERS += *.h
# Additional import path used to resolve QML modules in Qt Creator's code model
QML_IMPORT_PATH =

# Additional import path used to resolve QML modules just for Qt Quick Designer
QML_DESIGNER_IMPORT_PATH =

# Default rules for deployment.
qnx: target.path = /tmp/$${TARGET}/bin
else: unix:!android: target.path = /opt/$${TARGET}/bin
!isEmpty(target.path): INSTALLS += target

DISTFILES += \
    *.qml \
    ../test/tesCaseTimeOfAnswer.qml \
    ../test/testCaseAttributesSelecting.qml \
    About.qml \
    EditingArea.qml \
    ErrorWnd.qml \
    InOutSettings.qml \
    MenuDelegate.qml \
    Mode.qml \
    SideMenu.qml \
    Tutorial.qml \
    main_en.qm

RESOURCES += \
    qml.qrc

TRANSLATIONS = main_en.ts main_en.qm
