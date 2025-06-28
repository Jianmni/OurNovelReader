#include "speech.h"
#include <stdexcept>
#include <iostream>
Speech::Speech(QObject *parent) : QObject(parent)
{
    int sample_rate = espeak_Initialize(AUDIO_OUTPUT_PLAYBACK, 0, nullptr, 0);
    if (sample_rate <= 0) { throw std::runtime_error("Failed to initialize eSpeak"); }
}

Speech::~Speech()
{
    espeak_Terminate();
}
//判断选中的语言是否可以合成，应该只有cmn
void Speech::setVoice(const QString& voice_name) {
    if (espeak_SetVoiceByName(voice_name.toStdString().c_str()) != EE_OK) {
        std::cerr << "Warning: Failed to set voice to " << voice_name.toStdString() << std::endl;
    }
}
//语速
void Speech::setRate(int words_per_minute) {
    espeak_SetParameter(espeakRATE, words_per_minute, 0);
}
//声音大小
void Speech::setVolume(int volume) {
    espeak_SetParameter(espeakVOLUME, volume, 0);
}

// 获取当前文本列表
//QList<QString> Speech::textList() const {
//   return m_textList;
//}

// 设置新的文本列表，并触发信号
//void Speech::setTextList(const QList<QString>& newTextList) {
//if (m_textList != newTextList) {
//        m_textList = newTextList;
//        emit textListChanged();  // 通知 QML 数据已更新
//    }
//}
// 从 m_textList 中取出文本进行合成
//void Speech::speak() {
//    if (m_textList.isEmpty()) {
//        std::cerr << "Warning: No text to speak!" << std::endl;
//        return;
//    }
