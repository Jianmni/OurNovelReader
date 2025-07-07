#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>  // 添加这行
#include <QDir>

// my component
#include "bookmanager.h"
#include "booklistmanager.h"
#include "readengin.h"
#include "textmanager.h"

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);

    qmlRegisterType<BookManager>("BookManager", 1, 0, "BookManager");
    qmlRegisterType<BookListManager>("BookListManager", 1, 0, "BookListManager");
    qmlRegisterType<ReadEngin>("ReadEngin", 1, 0, "ReadEngin");
    qmlRegisterType<TextManager>("TextManager", 1, 0, "TextManager");

    QQmlApplicationEngine engine;

    // 获取应用程序所在目录
    QString appPath = QCoreApplication::applicationDirPath();
    // 设置为QML上下文属性
    engine.rootContext()->setContextProperty("appPath", appPath);

    QObject::connect(
        &engine,
        &QQmlApplicationEngine::objectCreationFailed,
        &app,
        []() { QCoreApplication::exit(-1); },
        Qt::QueuedConnection);
    engine.loadFromModule("NovelReader", "NovelReader");

    return app.exec();
}
