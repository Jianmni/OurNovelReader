// WF 2023051604037
// first complete at 2025/6/9
// 1-Load txt file, seperate chapters into different txt files
#pragma once

#include <QObject>

class LoadTxt: public QObject
{
    Q_OBJECT
public:
    explicit LoadTxt(QObject *parent = nullptr);

    Q_INVOKABLE bool loadLocalBook(const QString& filepath, int id);
    void createFiles();

    bool processText(const QString& filepath);
    bool writeChapter(const QStringList& context, const QString& title);
    void deleteAll();

signals:
    void loadComplete();
    void shouldInit();
    void loadFailed();

private:
    QString m_bookName;
    int m_chapterCount;
    QString m_bookDir;

    QStringList m_content;
};
