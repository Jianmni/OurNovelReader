#include "configmanager.h"

#include <QDir>
#include <QJsonArray>
#include <QJsonObject>

ConfigManager::ConfigManager() {}

void ConfigManager::initConfig()
{
    QDir dir(".");
    if (!dir.exists("config"))
        dir.mkdir("config");
    QFile config(m_configPath);
    if(!config.open(QIODeviceBase::NewOnly | QIODeviceBase::ReadWrite))
    {
        qWarning() << "On ConfigManager::initConfig: Create file failed: " + m_configPath;
        return;
    }

    QJsonObject obj  {};
    QJsonObject read {};
    read["bg"] = "#FAFAFA";
    read["fontSize"] = 16;
    read["fontType"] = "Helvetica";
    read["pageChange"] = "left-and-right";

    QJsonObject user {};
    user["name"] = "Welcome";
    user["sign"] = "认真对待阅读的每一分钟";
    QDateTime dt = QDateTime::currentDateTime();
    QString day = dt.toString("yyyy-mm-dd HH-mm-ss");
    user["day"] = day;

    QJsonObject listen {};
    listen["volume"] = 0;
    listen["speed"]  = 1;
    listen["choice"] = "circle";

    obj["read"]   = read;
    obj["user"]   = user;
    obj["listen"] = listen;

    QJsonDocument doc(obj);
    config.write(doc.toJson());
}

QList<QVariant> ConfigManager::getConfig()
{

}

void ConfigManager::updateConfig(const QList<QVariant> config)
{

}
