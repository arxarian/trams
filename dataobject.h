#ifndef DATAOBJECT_H
#define DATAOBJECT_H

#include <QObject>
#include <QtQml>
#include <QMetaProperty>
#include <QQmlListProperty>

// ************************************************************** //
// ********************* Data Object **************************** //
// ************************************************************** //

class DataObject : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QString name MEMBER m_strName NOTIFY nameChanged)
    Q_PROPERTY(double latitude MEMBER m_fLatitude NOTIFY latitudeChanged)
    Q_PROPERTY(double longitude MEMBER m_fLongitude NOTIFY longitudeChanged)
    Q_PROPERTY(bool added MEMBER m_bAdded NOTIFY addedChanged)
    Q_PROPERTY(bool origin MEMBER m_bOrigin NOTIFY originChanged)

    QString m_strName;
    double m_fLatitude;      /// šířka
    double m_fLongitude;     /// délka
    bool m_bAdded;
    bool m_bOrigin;

public:
    Q_INVOKABLE DataObject(QObject *parent = 0) : QObject(parent) {}
    //DataObject(const QString &strName, const double &fLatidude, const double &fLongitude, QObject *parent = 0);

signals:
    void nameChanged();
    void latitudeChanged();
    void longitudeChanged();
    void addedChanged();
    void originChanged();
};

// ************************************************************** //
// ******************* Data Model Manager *********************** //
// ************************************************************** //

class DataModelManager : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QQmlListProperty<QObject> data READ QmlData NOTIFY dataModelChanged())  //NOTIFY signál by dle dokumentace neměl fungovat, protože QmlList má být const. Nicméně to funguje
public:
    explicit DataModelManager(QObject *parent = 0);

    QQmlListProperty<QObject> QmlData();                /// Funkce vrací PropertyList pro QML
    QList<QObject *> GetData();                         /// Funkce vrací QList pro C++
    bool SetDataType(const QMetaObject &oMetaObject);   /// Nastavní datového typu, jenž Manager schraňuje

public slots:
    QObject *getItem(qint32 nIndex);                    /// C++/QML, funkce vrací jeden objekt datového modelu pro přímou editaci  (QML může přistupovat přímo přes Property)
    void setItem(qint32 nIndex, QVariantMap arrValues); /// C++/QML, nastavení jednoho až všech parametrů datového objektu (QML může přistupovat přímo přes Property)
    void appendItem(QVariantMap arrValues);             /// C++/QML, připojení nového datového objektu na konec modelu
    void removeItem(qint32 nIndex);                     /// C++/QML, odstranění libobolného datového objektu z modelu

signals:
    void dataModelChanged();                            /// Signál pro QML, který značí, že data v modelu se změnila (append/remove)

private:
    QList<QObject *> m_arrData;                         /// Data Model
    bool m_bDataClassSet;                               /// Indikuje, zda byla nastavena QObject-based datová třída pro ukládání dat
    QMetaObject m_oDataClassMetaObject;                 /// Meta Object uchovává informace o struktuře datové třídy
    QStringList DataObjectProperties();                 /// Metoda vrací properties datové třídy
};

#endif // DATAOBJECT_H
