#include "dataobject.h"

//DataObject::DataObject(const QString &strName, const double &fLatidude, const double &fLongitude, QObject *parent)
//    : m_strName(strName), m_fLatitude(fLatidude), m_fLongitude(fLongitude), QObject(parent)
//{
//    m_bAdded = m_bOrigin = false;
//}

DataModelManager::DataModelManager(QObject *parent) : QObject(parent)
{
    m_bDataClassSet = false;    // typ datového objektu není nastaven
}

QQmlListProperty<QObject> DataModelManager::QmlData()
{
    return QQmlListProperty<QObject>(this, m_arrData);
}

QList<QObject *> DataModelManager::GetData()
{
    return m_arrData;
}

bool DataModelManager::SetDataType(const QMetaObject &oMetaObject)
{
    if(!m_bDataClassSet)    //datový type je možné jen jednou nastavit
    {
        m_oDataClassMetaObject = oMetaObject;
        m_bDataClassSet = true;
        return true;
    }

    return false;
}

QObject *DataModelManager::getItem(qint32 nIndex)
{
    return m_arrData[nIndex];
}

void DataModelManager::setItem(qint32 nIndex, QVariantMap arrValues)
{
    if(m_bDataClassSet)
    {
        if(nIndex >= 0 && nIndex < m_arrData.count())
        {
            const QStringList c_arrProperties = DataObjectProperties();
            foreach (const QString strProperty, c_arrProperties)
            {
                if(arrValues.contains(strProperty))
                {
                    m_arrData[nIndex]->setProperty(strProperty.toStdString().c_str(), arrValues.find(strProperty).value());
                }
            }
            //emit dataModelChanged(); // TODO: udělat signál pro změnu dat a pro změnu počtu prvků?
        }
    }
}

void DataModelManager::appendItem(QVariantMap arrValues)
{
    if(m_bDataClassSet)
    {
        QObject *pObject = m_oDataClassMetaObject.newInstance();
        if(pObject != NULL)
        {
            const QStringList c_arrProperties = DataObjectProperties();
            foreach (const QString strProperty, c_arrProperties)
            {
                if(arrValues.contains(strProperty)) // je-li hodnota nastavena, nastaví se
                {
                    pObject->setProperty(strProperty.toStdString().c_str(), arrValues.find(strProperty).value());
                }
            }
            m_arrData.append(pObject);
            emit dataModelChanged();
        }
    }
}

void DataModelManager::removeItem(qint32 nIndex)
{
    if(nIndex >= 0 && nIndex < m_arrData.count())
    {
        m_arrData.at(nIndex)->deleteLater();
        m_arrData.removeAt(nIndex);
        emit dataModelChanged();
    }
}

QStringList DataModelManager::DataObjectProperties()
{
    QStringList arrProperties;
    if(arrProperties.isEmpty())
    {
        for(qint32 nIndex = 1; nIndex < m_oDataClassMetaObject.propertyCount(); nIndex++)  // the first property is className, therefore we skip it
        {
            arrProperties << m_oDataClassMetaObject.property(nIndex).name();
        }
    }
    return arrProperties;
}
