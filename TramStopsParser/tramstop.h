#ifndef TRAMSTOP_H
#define TRAMSTOP_H

#include <QtCore>

struct GpsPoint
{
    qreal qLatitude;    // NOTE - maybe it's more precise to store the coordinate in string data type
    qreal qLongitude;
    GpsPoint(const qreal& qLatitude, const qreal& qLongitude) : qLatitude(qLatitude), qLongitude(qLongitude) {}

    bool operator==(const GpsPoint& other) const
    {
        return ((this->qLatitude == (other.qLatitude)) && (this->qLongitude == (other.qLongitude)));
    }
};

struct TramStop
{
    QString strName;
    QList<GpsPoint> arrGpsPoints;

    bool operator==(const TramStop& other) const
    {
        return this->strName == (other.strName);
    }

    bool operator<(const TramStop& other) const
    {
        return this->strName.normalized(QString::NormalizationForm_D) < other.strName.normalized(QString::NormalizationForm_D);
    }
};

enum class StopTypes
{
    Metro = 0x01,
    Tram = 0x02,
    Bus = 0x04,
    TramBus = Tram | Bus,
    Funicular = 0x08,
    Train = 0x10,
    BusTrain = Bus | Train,
    Ship = 0x20,
};

#endif // TRAMSTOP_H
