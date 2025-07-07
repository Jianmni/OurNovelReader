// WF 2023051604037
// read engine for a single book
#pragma once

#include <QObject>
#include <QVariant>

#include <QtQml/qqmlregistration.h>

class ReadEngin : public QObject
{
    Q_OBJECT
    QML_ELEMENT
public:
    explicit ReadEngin(QObject *parent = nullptr);
    // load
    Q_INVOKABLE QList<QVariant> loadBookReadInfo(int bkId);
    Q_INVOKABLE QList<QString> loadBookContent();
    Q_INVOKABLE QList<QString> loadChapter(int chapterId);

    // save
    Q_INVOKABLE void writeProgress(int curContent, int curPage, int hour, int minu, int seco);
    Q_INVOKABLE void writePageNum(int pageNum) {m_totalPageNUm = pageNum;}

    bool getInfo(QList<QVariant> &ret);
signals:

private:
    QList<QVariant> m_bookInfo {};
    QList<QVariant> m_tmpForSave {};    // save progress when finish read
    QString m_bookPath {};
    int m_totalPageNUm {};
};
