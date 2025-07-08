//zzh 2023051604038
// TTS 但仅支持.txt 文件 所以如果导入PDF、DOC文件就只能先转换格式,但是我不想做这个
//espeak的中文合成真的抽象,后续也许调用美化包？
#pragma once

#include <QObject>
#include <QString>
#include <QList>
#include <espeak-ng/speak_lib.h>

class Speech: public QObject
{
    Q_OBJECT
    Q_PROPERTY(QList<QString> textList READ textList WRITE setTextList NOTIFY textListChanged)//添加一个QStringList，便于后续对小说文本的获取以及段落暂存功能预实现
public:
    explicit Speech(QObject *parent = nullptr);
    ~Speech();

    Q_INVOKABLE void setVoice(const QString& voice_name);
    Q_INVOKABLE void setRate(int words_per_minute);
    Q_INVOKABLE void setVolume(int volume);
    Q_INVOKABLE void speak(const QString& text);

private:
    Speech(const Speech&) = delete;
    Speech& operator=(const Speech&) = delete;
};
