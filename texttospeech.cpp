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
    //暂停部分
    m_remainingText = text.toStdString();
    m_isPaused = false;
    // 检查空文本,不管了先这样
    if (text.isEmpty()) {
        qWarning() << "Warning: Attempted to speak empty text";
        std::string utf8_text = "无内容,请重新选择书籍章节";
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
//暂停部分
void TextToSpeech::pause() {
    if (!m_isPaused) {
        espeak_Cancel(); // 中断当前播放
        m_isPaused = true;
    }
}

void TextToSpeech::resume() {
    if (m_isPaused && !m_remainingText.empty()) {
        // 重新播放剩余文本
        int result = espeak_Synth(
            m_remainingText.c_str(),
            m_remainingText.size() + 1,
            0,
            POS_CHARACTER,
            0,
            espeakCHARS_UTF8,
            nullptr,
            nullptr
            );
        if (result == EE_OK) {
            m_isPaused = false;
        }
    }
}

bool TextToSpeech::isSpeaking() const {
    return (espeak_IsPlaying() == 1) && !m_isPaused;
}
