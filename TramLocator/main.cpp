#include <QFile>
#include <QGuiApplication>
#include <QQmlContext>
#include <QQmlApplicationEngine>
#include <QDir>

#include <QDebug>

#include "datamodel.h"
#include "modelwrapper.h"

class TramStop
{
    Q_GADGET
    Q_PROPERTY(QString name MEMBER m_strName)
    Q_PROPERTY(qreal latitude MEMBER m_fLatitude)
    Q_PROPERTY(qreal longitude MEMBER m_fLongitude)

    QString m_strName;
    qreal m_fLatitude;  // S-N // délka // 14.3
    qreal m_fLongitude; // E-W // šířka // 50.0

public:
    TramStop() {}
};

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);

    QQmlApplicationEngine engine;

    DataModel<TramStop> dataModel;


//    QFile inputFile(QDir::currentPath() + "/zastavky.txt");
    QFile inputFile(":/zastavky.txt");
    if(inputFile.open(QIODevice::ReadOnly | QIODevice::Text))
    {
        QTextStream inStream(&inputFile);
        inStream.setCodec("UTF-8");
        QVariantMap map;

        while(!inStream.atEnd())
        {
            QStringList arrStrList = inStream.readLine().split(",");
            QString strArg;

            Q_ASSERT(arrStrList.count() == 4);

            map.insert("name", arrStrList.at(0));

            strArg = arrStrList.at(1);
            map.insert("latitude", strArg.toDouble());
            strArg = arrStrList.at(2);
            map.insert("longitude", strArg.toDouble());

            dataModel.append(map);
        }
    }

    qDebug() << dataModel.count();

    QQmlContext *ctxt = engine.rootContext();
    ctxt->setContextProperty("dataModel", &dataModel);
    ctxt->setContextProperty("compileTime", QVariant(__DATE__));
    ctxt->setContextProperty("appVersion", QString(APP_VERSION));

    engine.load(QUrl(QStringLiteral("qrc:/main.qml")));

    return app.exec();
}

#include "main.moc"
