#ifndef PROCESSFILE_H
#define PROCESSFILE_H

#include <QObject>
#include <QDomDocument>
#include <QFile>
#include <QDebug>
#include <algorithm>

#include "tramstop.h"

class ProcessFile
{
    QString m_strFileName;
    QList<TramStop> m_arrTramStops;

    void AddTramStop(const QString& strName, const quint32& nType, const QStringList& arrPosition);

public:
    ProcessFile() {}
    void SetFile(const QString& strFileName);
    void ParseFile();
    void ExportFile();
};

#endif // PROCESSFILE_H
