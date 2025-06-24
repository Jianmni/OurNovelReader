// WF 2023051604037
// read engine for a single book
#pragma once

#include <QObject>

class ReadEngin : public QObject
{
    Q_OBJECT
public:
    explicit ReadEngin(QObject *parent = nullptr);
    // load
    Q_INVOKABLE QList<QVariant> loadBookReadInfo(int bkId);
    Q_INVOKABLE QList<QString> loadBookContent(int bkId);
    Q_INVOKABLE QList<QString> loadChapter(int chapterId);

    // save
    Q_INVOKABLE void writeProgress(int curContent, int curPage);
    Q_INVOKABLE void writePageNum(int pageNum) {m_totalPageNUm = pageNum;}

    bool getInfo(QList<QVariant> &ret);
signals:

private:
    QList<QVariant> m_bookInfo {};
    QString m_bookPath {};
    int m_totalPageNUm {};
};
