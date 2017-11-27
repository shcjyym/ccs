#include <QApplication>
#include <QQmlApplicationEngine>
#include <QtQml>
#include <QDebug>
#include <QIcon>

#include "ccalcposgenconfigfile.h"

int main(int argc, char *argv[])
{
    QApplication app(argc, argv);
    app.setWindowIcon(QIcon(":/icons/LOGO.ico"));

    QQmlApplicationEngine engine;
    engine.rootContext()->setContextProperty("CCalcPosGenConfigFile",new CCalcPosGenConfigFile);
    engine.load(QUrl(QStringLiteral("qrc:///main.qml")));

    return app.exec();
}
