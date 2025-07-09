#pragma once

#include <QObject>
#include <QString>
#include <espeak-ng/speak_lib.h>

class TextToSpeech : public QObject
{
    Q_OBJECT
public:
    explicit TextToSpeech(QObject *parent = nullptr);
    ~TextToSpeech();

    Q_INVOKABLE void setVoice(const QString& voice_name);
    Q_INVOKABLE void setRate(int words_per_minute);
    Q_INVOKABLE void setVolume(int volume);
    Q_INVOKABLE void speak(const QString& text);
//暂停继续功能补充
    Q_INVOKABLE void pause();
    Q_INVOKABLE void resume();
    Q_INVOKABLE bool isSpeaking() const;

private:
    TextToSpeech(const TextToSpeech&) = delete;
    TextToSpeech& operator=(const TextToSpeech&) = delete;
//暂停继续功能补充
    std::string m_remainingText; // 剩余未播放文本
    bool m_isPaused = false;
};
