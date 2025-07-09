#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QDir>
#include <QQmlContext>  // 添加这行

#include "texttospeech.h"
#include "bookselector.h"
int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);

    BookSelector bookSelector;

    QQmlApplicationEngine engine;

    // 获取应用程序所在目录
    QString appPath = QCoreApplication::applicationDirPath();


    // 设置为QML上下文属性
    engine.rootContext()->setContextProperty("appPath", appPath);

    qmlRegisterType<BookSelector>("bookselector", 1, 0, "BookSelector");
    qmlRegisterType<TextToSpeech>("TextToSpeech", 1, 0, "TextToSpeech");

    QObject::connect(
        &engine,
        &QQmlApplicationEngine::objectCreationFailed,
        &app,
        []() { QCoreApplication::exit(-1); },
        Qt::QueuedConnection);
    engine.loadFromModule("NovelReader", "NovelReader");

    return app.exec();
}
