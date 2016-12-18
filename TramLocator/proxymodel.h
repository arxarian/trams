#ifndef PROXYMODEL_H
#define PROXYMODEL_H

#include <QSortFilterProxyModel>

class ProxyModel : public QSortFilterProxyModel
{
    Q_OBJECT
    Q_PROPERTY(int count READ count NOTIFY countChanged)
    Q_PROPERTY(QObject *source READ source WRITE setSource)

    Q_PROPERTY(qint32 sortRole READ sortRole WRITE setSortRole)
    Q_PROPERTY(Qt::SortOrder sortOrder READ sortOrder WRITE setSortOrder)

    Q_PROPERTY(qint32 filterRole READ filterRole WRITE setFilterRole)
    Q_PROPERTY(QString filterString READ filterString WRITE setFilterString)

public:
    explicit ProxyModel(QObject *parent = 0);

    QObject *source() const;
    void setSource(QObject *source);

    qint32 sortRole() const;
    void setSortRole(const qint32 role);

    void setSortOrder(Qt::SortOrder order);

    qint32 filterRole() const;
    void setFilterRole(const qint32 role);

    QString filterString() const;
    void setFilterString(const QString &filter);

    int count() const;

    Q_INVOKABLE qint32 mapToSource(qint32 nIndex) const;

signals:
    void countChanged();
};

#endif // PROXYMODEL_H
