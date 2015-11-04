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

    QFile oInputFile(":/zastavky.txt");
    if(oInputFile.open(QIODevice::ReadOnly | QIODevice::Text))
    {
        QTextStream oInStream(&oInputFile);
        oInStream.setCodec("UTF-8");
        QVariantMap map;

        while(!oInStream.atEnd())
        {
            QStringList arrStrList = oInStream.readLine().split(",");
            QString strArg;

            Q_ASSERT(arrStrList.count() == 4);

            map.insert("name", arrStrList.at(0));

            strArg = arrStrList.at(1);
            map.insert("latitude", strArg.toDouble());
            strArg = arrStrList.at(2);
            map.insert("longitude", strArg.toDouble());

            map.insert("added", false);
            map.insert("origin", false);
            oDataModel.appendItem(map);
        }
    }

    qDebug() << oDataModel.GetData().count();

    QQmlContext *ctxt = engine.rootContext();
    ctxt->setContextProperty("dataModel", &oDataModel);

    engine.load(QUrl(QStringLiteral("qrc:/main.qml")));

    return app.exec();
}

