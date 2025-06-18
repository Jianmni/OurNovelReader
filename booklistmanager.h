#pragma once

#include <QObject>
#include <QString>
#include <QJsonArray>
#include <QJsonObject>

class BookListManager : public QObject
{
public:
    explicit BookListManager(QObject *parent = nullptr);
    bool initBookList();    // if booklist.json is not exist

    bool load();
    bool save();

    bool addBook(const QString &name);
    bool deleteBook(int id);

    // 根据ID获取书籍
    int getBookPos(int id) const;
    int bookSum() {return m_sum;}

signals:
    void shouldInit();

private:
    int m_sum = 1;
    int m_realSum = 1;
    QJsonArray m_bookList = QJsonArray();
};
