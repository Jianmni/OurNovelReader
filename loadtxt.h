// WF 2023051604037
// 2025-6-9 -- 2025-7-8
// 1-Load txt file, seperate chapters into different txt files
// 加载本地文本
// 处理文本
// 书籍书籍删除操作
#pragma once

#include <QObject>
#include <QtQml/qqmlregistration.h>

class LoadTxt: public QObject
{
    Q_OBJECT
    QML_ELEMENT
public:
    explicit LoadTxt(QObject *parent = nullptr);

    Q_INVOKABLE bool loadLocalBook(const QString& filepath, int id);
    void createFiles();
    // void copyCover();

    bool processText(const QString& filepath);
    bool processInfo(const QString& filepath);
    bool writeChapter(const QStringList& context, const QString& title);
    void deleteBook();
    void deleteBook(int id);

signals:
    void shouldInit();

private:
    int m_chapterCount = 0;
    QString m_bookDir = ".";

    QStringList m_content {};
};
