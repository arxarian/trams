#include <QFile>
#include <QGuiApplication>
#include <QQmlContext>
#include <QQmlApplicationEngine>
#include <QDir>
#include <QtQml>

#include <QDebug>

#include "datamodel.h"
#include "modelwrapper.h"
#include "proxymodel.h"

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

// TODO list
// b - try differnt resolution (e. g. virtual device or desktop app)
// c - online update of data
// d - online update of app
// z - do others todos

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);

    QQmlApplicationEngine engine;

    DataModel<TramStop> dataModel;


//    QFile inputFile(QDir::currentPath() + "/zastavky.txt");
    QFile inputFile(":/tramStops.csv");
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

    qmlRegisterType<ProxyModel>("ProxyModel", 1, 0, "ProxyModel");
    QQmlContext *ctxt = engine.rootContext();
    ctxt->setContextProperty("dataModel", &dataModel);
    ctxt->setContextProperty("compileTime", QVariant(__DATE__));        // TODO - replace by real time of last update (N2H - display time of last online update check)
    ctxt->setContextProperty("appVersion", QString(APP_VERSION));       // TODO - different from android manifest version, why? (http://doc.qt.io/qt-5/deployment-android.html? http://blog.qt.io/blog/2013/07/23/anatomy-of-a-qt-5-for-android-application/?)

    engine.load(QUrl(QStringLiteral("qrc:/main.qml")));

    return app.exec();
}

#include "main.moc"
