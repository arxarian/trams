/*!
  \file   datamodel.h
  \author Pavel Hübner
  \date   25. 5. 2016
  \brief  datový model pro C++/QML postavený na šablonách
*/

#ifndef TEMPLATEDATAMODEL_H
#define TEMPLATEDATAMODEL_H

#include <QMetaProperty>

#include "modelwrapper.h"

template <class T>
class DataModel : public ModelWrapper
{
        QList<T> m_arrData;                                     // the list of stored data
        QHash<int, QByteArray> m_arrRoleToName;                 // 'role' to 'property name'
        QMap<qint32, qint32> m_arrRoleToIndex;                  // 'role' to 'property index'
        const QMetaObject m_metaObject = T::staticMetaObject;   // item static meta object (this class uses Q_PROPERTY to read/write item's data)

public:
        DataModel()
        {
            // create roles from T's properties
            qint32 nRoleIndex = Qt::UserRole;
            for(int i = m_metaObject.propertyOffset(); i < m_metaObject.propertyCount(); ++i)
            {
                m_arrRoleToName.insert(nRoleIndex++, m_metaObject.property(i).name());
            }

            // create 'role' to 'property index' map
            for(auto value : m_arrRoleToName.values())
            {
                m_arrRoleToIndex.insert(m_arrRoleToName.key(value), m_metaObject.indexOfProperty(value));
            }
        }

        int find(const QString &propertyName, const QVariant &value) const  // find item by property name and property value
        {
            qint32 nPropertyIndex = m_metaObject.indexOfProperty(propertyName.toStdString().c_str());
            if(nPropertyIndex < 0) return -1;

            for(qint32 nIndex = 0; nIndex < m_arrData.count(); ++nIndex)
            {
                if(m_metaObject.property(nPropertyIndex).readOnGadget(&m_arrData.at(nIndex)) == value)
                {
                    return nIndex;
                }
            }
            return -1;
        }

        // QAbstractItemModel interface
public:
        int rowCount(const QModelIndex &parent) const override
        {
            Q_UNUSED(parent)
            return count();
        }

        QVariant data(const QModelIndex &index, int role) const override                    // get data - view interface
        {
            int row = index.row();
            if(row < 0 || row >= m_arrData.count() || !m_arrRoleToName.contains(role)) return QVariant();

            return m_metaObject.property(m_arrRoleToIndex[role]).readOnGadget(&m_arrData.at(row));
        }

        bool setData(const QModelIndex &index, const QVariant &value, int role) override    // set data - view interface
        {
            int row = index.row();
            if(row < 0 || row >= m_arrData.count() || !value.isValid() || !m_arrRoleToName.contains(role)) return false;

            qint32 nPropertyIndex = m_arrRoleToIndex.value(role, -1);
            if(nPropertyIndex < 0) return false;

            if(m_metaObject.property(nPropertyIndex).readOnGadget(&m_arrData.at(row)) != value)
            {
                if(m_metaObject.property(nPropertyIndex).writeOnGadget(&m_arrData[row], value))
                {
                    emit ModelWrapper::contentChanged(row, QList<int>() << role);
                    return true;
                }
            }
            return false;
        }

        Qt::ItemFlags flags(const QModelIndex &index) const override
        {
            if(!index.isValid()) return Qt::ItemIsEnabled;
            return QAbstractItemModel::flags(index) | Qt::ItemIsEditable;
        }

        QHash<int, QByteArray> roleNames() const override
        {
            return m_arrRoleToName;
        }


        // ModelWrapper interface
public:
        void clear() override
        {
            if(m_arrData.isEmpty()) return;

            beginRemoveRows(QModelIndex(), 0, m_arrData.count() - 1);
            m_arrData.clear();
            endRemoveRows();
            emit ModelWrapper::countChanged(m_arrData.count());
        }

        void insert(int row, const QVariantMap &arrValues) override
        {
            if(row < 0 || row > m_arrData.count()) return;
            beginInsertRows(QModelIndex(), row, row);

            T t;
            for(auto key : arrValues.keys())
            {
                qint32 nPropertyIndex = m_metaObject.indexOfProperty(key.toStdString().c_str());
                if(nPropertyIndex < 0)
                {
                    qWarning() << "object properties and model roles are not the same, nonexistent property:" << key << ", class" << m_metaObject.className(); // závilost na QDebug
                    continue;
                }
                m_metaObject.property(nPropertyIndex).writeOnGadget(&t, arrValues.value(key));
            }
            m_arrData.insert(row, t);
            endInsertRows();

            emit ModelWrapper::countChanged(m_arrData.count());
        }

        void append(const QVariantMap &arrValues) override
        {
            insert(count(), arrValues);
        }

        void remove(int row, int n) override
        {
            if(row < 0 || row >= m_arrData.count()) return;

            beginRemoveRows(QModelIndex(), row, row + n - 1);

            for(int i = 0; i < n; ++i)
            {
                m_arrData.removeAt(row);
            }

            endRemoveRows();
            emit ModelWrapper::countChanged(m_arrData.count());
        }

        QVariantMap get(int row) const override
        {
            if(row < 0 || row >= m_arrData.count()) return QVariantMap();

            const T &t = m_arrData.at(row);
            QVariantMap vMap;
            for(int nPropertyIndex = m_metaObject.propertyOffset(); nPropertyIndex < m_metaObject.propertyCount(); ++nPropertyIndex) {
                vMap.insert(m_metaObject.property(nPropertyIndex).name(), m_metaObject.property(nPropertyIndex).readOnGadget(&t));
            }

            return vMap;
        }

        QVariant getProperty(int row, const QString &name) const override
        {
            if(row < 0 || row >= m_arrData.count()) return QVariant();

            const T &t = m_arrData.at(row);
            qint32 nPropertyIndex = m_metaObject.indexOfProperty(name.toStdString().c_str());

            if(nPropertyIndex < 0)
            {
                qWarning() << "object properties and model roles are not the same, nonexistent property:" << name << ", class" << m_metaObject.className();
                return QVariant();
            }

            return m_metaObject.property(nPropertyIndex).readOnGadget(&t);
        }

        void set(int row, const QVariantMap &arrValues) override
        {
            if(row < 0 || row >= m_arrData.count()) return;

            T &t = m_arrData[row];
            QList<int> arrChangedRoles;
            for(auto key : arrValues.keys())
            {
                qint32 nPropertyIndex = m_metaObject.indexOfProperty(key.toStdString().c_str());

                if(nPropertyIndex < 0)
                {
                    qWarning() << "object properties and model roles are not the same, nonexistent property:" << key << ", class" << m_metaObject.className();
                    continue;
                }
                if(m_metaObject.property(nPropertyIndex).readOnGadget(&m_arrData.at(row)) != arrValues.value(key))
                {
                    m_metaObject.property(nPropertyIndex).writeOnGadget(&t, arrValues[key]);
                    arrChangedRoles << nPropertyIndex;
                }
            }

            if(!arrChangedRoles.isEmpty()) emit ModelWrapper::contentChanged(row, arrChangedRoles);
        }

        void setProperty(int row, const QString &name, const QVariant &value) override
        {
            if(row < 0 || row >= m_arrData.count()) return;

            T &t = m_arrData[row];
            qint32 nPropertyIndex = m_metaObject.indexOfProperty(name.toStdString().c_str());

            if(nPropertyIndex < 0)
            {
                qWarning() << "object properties and model roles are not the same, nonexistent property:" << name;
                return;
            }

            if(m_metaObject.property(nPropertyIndex).readOnGadget(&m_arrData.at(row)) != value)
            {
                m_metaObject.property(nPropertyIndex).writeOnGadget(&t, value);
                emit ModelWrapper::contentChanged(row, QList<int>() << m_arrRoleToName.key(name.toLocal8Bit()));
            }
        }

        void move(int fromRow, int toRow) override
        {
            if(fromRow < 0 || toRow < 0 || fromRow >= m_arrData.count() || toRow >= m_arrData.count()) return;
            if(!beginMoveRows(QModelIndex(), fromRow, fromRow, QModelIndex(), toRow > fromRow ? toRow + 1 : toRow)) return;

            m_arrData.move(fromRow, toRow);
            endMoveRows();
        }

        int count() const override
        {
            return m_arrData.count();
        }

        int roleId(const QString &role) const override
        {
            return m_arrRoleToName.key(role.toLocal8Bit());
        }
};

#endif // TEMPLATEDATAMODEL_H
