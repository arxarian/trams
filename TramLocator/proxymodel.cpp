#include <QtQml>

#include "proxymodel.h"

ProxyModel::ProxyModel(QObject *parent) : QSortFilterProxyModel(parent)
{
    connect(this, SIGNAL(rowsInserted(QModelIndex,int,int)), this, SIGNAL(countChanged()));
    connect(this, SIGNAL(rowsRemoved(QModelIndex,int,int)), this, SIGNAL(countChanged()));

    QSortFilterProxyModel::setSortCaseSensitivity(Qt::CaseInsensitive);
}

int ProxyModel::count() const
{
    return rowCount();
}

qint32 ProxyModel::mapToSource(qint32 nIndex) const
{
    return QSortFilterProxyModel::mapToSource(index(nIndex, 0)).row();
}

QObject *ProxyModel::source() const
{
    return sourceModel();
}

void ProxyModel::setSource(QObject *source)
{
    setSourceModel(qobject_cast<QAbstractItemModel *>(source));
}

qint32 ProxyModel::sortRole() const
{
    return QSortFilterProxyModel::sortRole();
}

void ProxyModel::setSortRole(const qint32 role)
{
    QSortFilterProxyModel::setSortRole(role);
}

void ProxyModel::setSortOrder(Qt::SortOrder order)
{
    QSortFilterProxyModel::sort(0, order);
}

qint32 ProxyModel::filterRole() const
{
    return QSortFilterProxyModel::filterRole();
}

void ProxyModel::setFilterRole(const qint32 role)
{
    QSortFilterProxyModel::setFilterRole(role);
}

QString ProxyModel::filterString() const
{
    return filterRegExp().pattern();
}

void ProxyModel::setFilterString(const QString &filter)
{
    setFilterRegExp(QRegExp(filter, Qt::CaseInsensitive, QRegExp::RegExp));
}
