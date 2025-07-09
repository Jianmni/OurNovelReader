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

private:
    TextToSpeech(const TextToSpeech&) = delete;
    TextToSpeech& operator=(const TextToSpeech&) = delete;
};
