#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QDir>

#include <QQmlContext>  // 添加这行

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);

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
