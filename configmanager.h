// WF 2023051604037
// 2025-6-24 -- 2025-7-8
// 配置管理
// 管理播放、阅读、用户信息配置
#pragma once

#include <QJsonObject>
#include <QObject>

#include <QtQml/qqmlregistration.h>

class ConfigManager: public QObject
{
    Q_OBJECT
    QML_ELEMENT
public:
    ConfigManager();

    Q_INVOKABLE void initConfig();
    // get config
    Q_INVOKABLE QList<QVariant> getReadConfig();
    Q_INVOKABLE QList<QVariant> getUserConfig();
    Q_INVOKABLE QList<QVariant> getListenConfig();
    // update config
    Q_INVOKABLE void updateReadConfig(const QList<QVariant> config);
    Q_INVOKABLE void updateUserCOnfig(const QList<QVariant> config);
    Q_INVOKABLE void updateListenConfig(const QList<QVariant> config);

private:
    void loadConfig();
    void updateConfig();

private:
    QString m_configPath = "config/config.json";
    QJsonObject m_read {};
    QJsonObject m_user {};
    QJsonObject m_listen {};
};
