#include "processfile.h"

void ProcessFile::AddTramStop(const QString &strName, const quint32 &nType, const QStringList &arrPosition)
{
    if(nType == static_cast<quint32>(StopTypes::Tram) || nType == static_cast<quint32>(StopTypes::TramBus) || arrPosition.size() != 2)
    {
        TramStop oTramStop;
        oTramStop.strName = strName;

        qint32 nTramStopIndex = m_arrTramStops.indexOf(oTramStop);
        GpsPoint oGpsPoint(arrPosition.at(0).toDouble(), arrPosition.at(1).toDouble());
        if(nTramStopIndex < 0)
        {
            oTramStop.arrGpsPoints.append(oGpsPoint);
            m_arrTramStops.append(oTramStop);
        }
        else
        {
            if(!m_arrTramStops.at(nTramStopIndex).arrGpsPoints.contains(oGpsPoint))
            {
                m_arrTramStops[nTramStopIndex].arrGpsPoints.append(oGpsPoint);
            }
        }
    }
}

void ProcessFile::SetFile(const QString &strFileName)
{
    if(QFile::exists(strFileName))
    {
        qDebug() << "file exists";
        m_strFileName = strFileName;
    }
}

void ProcessFile::ParseFile()
{
    if(m_strFileName.isEmpty())
    {
        qDebug() << "no file selected";
        return;
    }

    QDomDocument oDoc;
    QFile oFile(m_strFileName);
    if (!oFile.open(QIODevice::ReadOnly) || !oDoc.setContent(&oFile))
    {
        qDebug() << "cannot load file or parse content";
        return;
    }

    QDomNodeList arrStops = oDoc.elementsByTagName("fme:DOP_PID_ZAST_POPIS_TS_B");
    qDebug() << "loaded" << arrStops.size() << "stops";
    for (int nStopIndex = 0; nStopIndex < arrStops.size(); nStopIndex++)
    {
        QDomNode oStop = arrStops.item(nStopIndex);

        QDomElement oStopName = oStop.firstChildElement("fme:ZAST_NAZEV");
        QDomElement oStopType = oStop.firstChildElement("fme:ZAST_DD");
        QDomElement oStopPointProperty = oStop.firstChildElement("gml:pointProperty");

        if(oStopName.isNull() || oStopType.isNull() || oStopPointProperty.isNull())
        {
            qDebug() << "xml structure error";
            continue;
        }

        QDomElement oStopPoint = oStopPointProperty.firstChildElement("gml:Point");
        if(oStopPoint.isNull())
        {
            qDebug() << "xml structure error";
            continue;
        }

        QDomElement oStopPosition = oStopPoint.firstChildElement("gml:pos");
        if(oStopPosition.isNull())
        {
            qDebug() << "xml structure error";
            continue;
        }

        AddTramStop(oStopName.text(), oStopType.text().toUInt(), oStopPosition.text().split(' '));
    }

    qDebug() << "parsed" << m_arrTramStops.size() << "tram stops";
}

void ProcessFile::SortAlphabetically()
{
    std::sort(m_arrTramStops.begin(), m_arrTramStops.end()/*, TramStop::TramStopLessThan*/);
}

void ProcessFile::ExportFile()
{
    QString strOutputFileName("tramStops.csv");
    QFile oFile(strOutputFileName);

    if(!oFile.open(QFile::WriteOnly))
    {
        qDebug() << "cannot open file for data export";
        return;
    }

    QTextStream outStream(&oFile);
    outStream.setCodec("UTF-8");
    outStream.setRealNumberPrecision(10);

    for(auto& oTramStop : m_arrTramStops)
    {
        outStream << oTramStop.strName << "," << oTramStop.arrGpsPoints.first().qLatitude << "," << oTramStop.arrGpsPoints.first().qLongitude << "," << endl;
    }
    qDebug() << "data stored to" << strOutputFileName;
}
