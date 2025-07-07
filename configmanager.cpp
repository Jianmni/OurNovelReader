#include "configmanager.h"

#include <QDir>
#include <QJsonArray>
#include <QJsonObject>

ConfigManager::ConfigManager()
{
    loadConfig();
}

void ConfigManager::initConfig()
{
    QDir dir(".");
    if (!dir.exists("config"))
        dir.mkdir("config");
    else return;

    QFile config(m_configPath);
    if(!config.open(QIODeviceBase::NewOnly | QIODeviceBase::ReadWrite))
    {
        qWarning() << "On ConfigManager::initConfig: Create file failed: " + m_configPath;
        return;
    }

    QJsonObject obj  {};

    // read
    m_read["bg"] = "#FAFAFA";                 // 阅读背景
    m_read["fontSize"] = 16;                  // 字体大小
    m_read["fontType"] = "Helvetica";         // 字体
    m_read["pageChange"] = "left-and-right";  // 翻页模式： left-and-right， top-and-bottom
    m_read["autoRead"] = false;               // 自动阅读
    m_read["autoReadSpeed"] = 0;              // 从0到1，5s/行 -> 1s/行
    m_read["edgeMargin"] = 25;                // 文本边距：15 ~ 40

    // user
    m_user["name"] = "读者";                  // 用户名
    m_user["sign"] = "认真对待阅读的每一分钟";   // 用户签名
    QDateTime dt = QDateTime::currentDateTime();
    QString day = dt.toString("yyyy-mm-dd HH-mm-ss");
    m_user["day"] = day;                      // 用户首次使用时期

    // listen config
    m_listen["volume"] = 0;                   // 音量
    m_listen["speed"]  = 1;                   // 阅读速度
    m_listen["choice"] = "circle";            // 阅读方式：循环、顺序播放

    obj["read"]   = m_read;
    obj["user"]   = m_user;
    obj["listen"] = m_listen;

    QJsonDocument doc(obj);
    config.write(doc.toJson());
}

QList<QVariant> ConfigManager::getReadConfig()
{
    QList<QVariant> ret {};

    ret.append(m_read["bg"].toString());
    ret.append(m_read["fontType"].toString());
    ret.append(m_read["pageChange"].toString());
    ret.append(m_read["fontSize"].toInt());
    ret.append(m_read["edgeMargin"].toInt());
    ret.append(m_read["autoRead"].toBool());
    ret.append(m_read["autoReadSpeed"].toInt());

    return ret;
}

QList<QVariant> ConfigManager::getUserConfig()
{
    QList<QVariant> ret {};

    ret.append(m_user["name"].toString());
    ret.append(m_user["sign"].toString());

    return ret;
}

QList<QVariant> ConfigManager::getListenConfig()
{
    QList<QVariant> ret {};

    ret.append(m_listen["volume"].toInt());
    ret.append(m_listen["speed"].toInt());
    ret.append(m_listen["choice"].toString());

    return ret;
}

void ConfigManager::updateReadConfig(const QList<QVariant> config)
{

}

void ConfigManager::updateUserCOnfig(const QList<QVariant> config)
{

}

void ConfigManager::updateListenConfig(const QList<QVariant> config)
{

}

void ConfigManager::loadConfig()
{
    QFile config(m_configPath);
    if(!config.open(QIODeviceBase::ReadOnly))
    {
        qWarning() << "In ConfigManager::initConfig: Open file failed: " + m_configPath;
        if (!QFile::exists(m_configPath))
        {
            qWarning() << "In ConfigManager::initConfig: File not exist, init now: " + m_configPath;
            initConfig();
        }
        return;
    }

    QByteArray data = config.readAll();
    QJsonDocument doc(QJsonDocument::fromJson(data));
    QJsonObject obj = doc.object();

    m_read = obj["read"].toObject();
    m_user = obj["user"].toObject();
    m_listen = obj["listen"].toObject();
}

void ConfigManager::updateConfig()
{
    QFile config(m_configPath);
    if(!config.open(QIODeviceBase::WriteOnly))
    {
        qWarning() << "In ConfigManager::initConfig: Open file failed: " + m_configPath;
        if (!QFile::exists(m_configPath))
        {
            qWarning() << "In ConfigManager::initConfig: File not exist, init now: " + m_configPath;
            initConfig();
        }
        return;
    }

    QJsonObject obj;
    obj["read"]   = m_read;
    obj["user"]   = m_user;
    obj["listen"] = m_listen;

    QJsonDocument doc(obj);
    config.write(doc.toJson());
}
