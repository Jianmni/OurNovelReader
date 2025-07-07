#pragma once

#include <QObject>

class ConfigManager: public QObject
{
    Q_OBJECT
public:
    ConfigManager();

    Q_INVOKABLE void initConfig();
    Q_INVOKABLE QList<QVariant> getConfig();
    Q_INVOKABLE void updateConfig(const QList<QVariant> config);

private:
    QString m_configPath = "config/config.json";
};
