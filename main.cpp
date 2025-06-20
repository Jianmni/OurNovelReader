#include <QGuiApplication>
#include <QQmlApplicationEngine>

// my component
//#include "bookmanager.h"

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);

    //qmlRegisterType<BookManager>("BookManager", 1, 0, "BookManager");

    QQmlApplicationEngine engine;
    QObject::connect(
        &engine,
        &QQmlApplicationEngine::objectCreationFailed,
        &app,
        []() { QCoreApplication::exit(-1); },
        Qt::QueuedConnection);
    engine.loadFromModule("NovelReader", "NovelReader");

    return app.exec();
}
