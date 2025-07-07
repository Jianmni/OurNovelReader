//2023051604038zhangzhihao
//一个可以运行的版本，只要将 utf8_text = 对应的string类型就可以，eSpeak本身不支持QList<QString>类型值，所以要实现一系列功能要通过线程等一系列操作

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
void Speech::speak(const QString& text)
{
    std::string utf8_text = "测试";//
    utf8_text += '\0';

    int result = espeak_Synth(utf8_text.c_str(),
                              utf8_text.size(),
                              0,
                              POS_CHARACTER,
                              0,
                              espeakCHARS_UTF8,
                              nullptr,
                              nullptr);

    if (result != EE_OK) {
        std::cerr << "Error synthesizing speech" << std::endl;
        return;
    }
    espeak_Synchronize();
}
