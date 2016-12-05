TEMPLATE = app

QT += qml quick
CONFIG += c++11

SOURCES += main.cpp

RESOURCES += qml.qrc

DEFINES += APP_VERSION=\\\"1.1.0\\\"

# Additional import path used to resolve QML modules in Qt Creator's code model
QML_IMPORT_PATH =

# Default rules for deployment.
include(deployment.pri)

HEADERS += \
    datamodel.h \
    modelwrapper.h \
    proxymodel.h

SOURCES += \
    proxymodel.cpp

DISTFILES += \
    android/AndroidManifest.xml \
    android/gradle/wrapper/gradle-wrapper.jar \
    android/gradlew \
    android/res/values/libs.xml \
    android/build.gradle \
    android/gradle/wrapper/gradle-wrapper.properties \
    android/gradlew.bat

ANDROID_PACKAGE_SOURCE_DIR = $$PWD/android
