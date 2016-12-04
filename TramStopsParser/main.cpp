#include "processfile.h"

int main(int argc, char *argv[])
{
    Q_UNUSED(argc)
    Q_UNUSED(argv)

    ProcessFile oProcessFile;
    oProcessFile.SetFile("../../Tram/TramStopsParser/DOP_PID_ZAST_POPIS_TS_B.gml");
    oProcessFile.ParseFile();
    oProcessFile.SortAlphabetically();
    oProcessFile.ExportFile();
}
