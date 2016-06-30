/*!
  \file   templatelistmodel.h
  \author Pavel Hübner
  \date   25. 5. 2016
  \brief  abstraktní třída definující rozhraní datového modelu v QML
*/

#ifndef TEMPLATELISTMODEL_H
#define TEMPLATELISTMODEL_H

#include <QAbstractListModel>

class ModelWrapper : public QAbstractListModel
{
    Q_OBJECT
    Q_PROPERTY(int count READ count NOTIFY countChanged)

public:
    explicit ModelWrapper(QObject *parent = 0) : QAbstractListModel(parent)
    {
        connect(this, &ModelWrapper::contentChanged, [this] (const int row)
        {
            emit QAbstractListModel::dataChanged(this->index(row), this->index(row));
        });

    }
    ~ModelWrapper() {}  // TODO - musím definovat funkci? ANO? NE? To samé konstruktor výše

    Q_INVOKABLE virtual void supressSignals(const bool &bSupress)
    {
        this->blockSignals(bSupress);
    }

    Q_INVOKABLE virtual void clear() = 0;
    Q_INVOKABLE virtual void insert(int row, const QVariantMap &arrValues) = 0;
    Q_INVOKABLE virtual void append(const QVariantMap &arrValues) = 0;
    Q_INVOKABLE virtual void remove(int row, int n = 1) = 0;

    Q_INVOKABLE virtual QVariantMap get(int row) const = 0; // TODO - předělat na JSValue, který podporuje JS v QML (Qt to převádání)
    Q_INVOKABLE virtual QVariant getProperty(int row, const QString& name) const = 0;
    Q_INVOKABLE virtual void set(int row, const QVariantMap &arrValues) = 0;
    Q_INVOKABLE virtual void setProperty(int row, const QString& name, const QVariant &value) = 0;
    Q_INVOKABLE virtual void move(int fromRow, int toRow) = 0;

    Q_INVOKABLE virtual int roleId(const QString &role) const = 0;  // TODO - najít náhradu např. v QMAP<QString, int>

    virtual int count() const = 0;  // NOTE - count není Q_INVOKABLE, protože je Q_PROPERTY a přístupný z QML jako property

signals:
    void countChanged(int count);
    void contentChanged(const int row, const QList<int> &roles = QList<int>());
};

#endif // TEMPLATELISTMODEL_H
