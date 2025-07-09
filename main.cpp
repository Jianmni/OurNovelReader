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

        QGuiApplication app(argc, argv);

        // 获取并准备存储路径
        QString storagePath = QStandardPaths::writableLocation(QStandardPaths::AppLocalDataLocation);
        storagePath.append(QStringLiteral("/novels/"));

        QDir dir;
        if (!dir.exists(storagePath)) {
            if (!dir.mkpath(storagePath)) {
                qCritical() << "Failed to create storage directory:" << storagePath;
                return -1;
            }
            qInfo() << "Created storage directory:" << storagePath;
        }

        // 确保路径格式正确
        storagePath = QDir::cleanPath(storagePath) + QLatin1String("/");

        QQmlApplicationEngine engine;

        //设置上下文属性
        engine.rootContext()->setContextProperty(QStringLiteral("appStoragePath"), storagePath);
        engine.rootContext()->setContextProperty(QStringLiteral("appVersion"), QStringLiteral("1.0.0"));

        QObject::connect(
            &engine,
            &QQmlApplicationEngine::objectCreationFailed,
            &app,
            []() { QCoreApplication::exit(-1); },
                         Qt::QueuedConnection);

        engine.loadFromModule("NovelReader", "Main");

        return app.exec();
}
