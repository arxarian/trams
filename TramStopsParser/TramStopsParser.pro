QT += core xml
QT -= gui

CONFIG += c++11

TARGET = TramStopsParser
#CONFIG += console
CONFIG -= app_bundle

TEMPLATE = app

SOURCES += main.cpp \
    processfile.cpp

HEADERS += \
    processfile.h \
    tramstop.h
