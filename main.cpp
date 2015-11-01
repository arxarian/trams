#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QDebug>
#include "dataobject.h"

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);

    QQmlApplicationEngine engine;

    DataModelManager oDataModel;
    oDataModel.SetDataType(DataObject::staticMetaObject);

    QVariantMap map;

    map.insert("name", "Hradčanská");
    map.insert("added", false);
    map.insert("origin", false);
    oDataModel.appendItem(map);
    map.insert("name", "Malostranské náměstí");
    map.insert("added", false);
    map.insert("origin", false);
    oDataModel.appendItem(map);
    map.insert("name", "Náměstí míru");
    map.insert("added", false);
    map.insert("origin", false);
    oDataModel.appendItem(map);
    map.insert("name", "Vítězné náměstí");
    map.insert("added", false);
    map.insert("origin", false);
    oDataModel.appendItem(map);
    Q_ASSERT(oDataModel.GetData().count() == 4);

    QQmlContext *ctxt = engine.rootContext();
    ctxt->setContextProperty("dataModel", &oDataModel);

    engine.load(QUrl(QStringLiteral("qrc:/main.qml")));

    return app.exec();
}

