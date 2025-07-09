#include "texttospeech.h"
#include <stdexcept>
#include <iostream>
#include <QDebug>

TextToSpeech::TextToSpeech(QObject *parent) : QObject(parent)
{
    int sample_rate = espeak_Initialize(AUDIO_OUTPUT_PLAYBACK, 0, nullptr, 0);
    if (sample_rate <= 0) { throw std::runtime_error("Failed to initialize eSpeak"); }
}

TextToSpeech::~TextToSpeech()
{
    espeak_Terminate();
}

void TextToSpeech::setVoice(const QString& voice_name)
{
    if (espeak_SetVoiceByName(voice_name.toStdString().c_str()) != EE_OK) {
        std::cerr << "Warning: Failed to set voice to " << voice_name.toStdString() << std::endl;
    }
}

void TextToSpeech::setRate(int words_per_minute)
{
    espeak_SetParameter(espeakRATE, words_per_minute, 0);
}

void TextToSpeech::setVolume(int volume)
{
    espeak_SetParameter(espeakVOLUME, volume, 0);
}

void TextToSpeech::speak(const QString& text)
{
    // 检查空文本
    if (text.isEmpty()) {
        qWarning() << "Warning: Attempted to speak empty text";
        std::string utf8_text = "无内容";

        return;
    }

    std::string utf8_text = text.toStdString();
    utf8_text += '\0';  // 确保 null-terminated

    int result = espeak_Synth(
        utf8_text.c_str(),
        utf8_text.size(),  // size() 已包含 null 终止符（toStdString() 会自动添加）
        0,
        POS_CHARACTER,
        0,
        espeakCHARS_UTF8,
        nullptr,
        nullptr
        );

    if (result != EE_OK) {
        qWarning() << "Speech synthesis failed with error code:" << result;
        return;
    }
    espeak_Synchronize();
}
