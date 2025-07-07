#pragma once

#include <QObject>
#include <QString>
#include <QJsonArray>
#include <QJsonObject>
#include <QList>
#include <QVariant>
#include <QtQml/qqmlregistration.h>

class BookListManager : public QObject
{
    Q_OBJECT
    QML_ELEMENT
public:
    explicit BookListManager(QObject *parent = nullptr);

    bool initBookList();    // if booklist.json is not exist
    Q_INVOKABLE bool load();
    bool save();            // save before quit app and after every kind of changes

    bool addBook(const QString &name);  // add to array and list file, change orders
    bool deleteBook(int id);            // delete from array and list file, change orders

    // 根据ID获取书籍
    int getBookPos(int id) const;       // get book pos in array
    int bookSum() {return m_sum;}       // for adding new book

    Q_INVOKABLE QList<QVariant> getReadOrder();     // return book's id and name
    Q_INVOKABLE QList<QVariant> getJoinOrder();
    Q_INVOKABLE void changeReadOrder(int bookId);   // change read order if the opened book
                                        // is not the first  in bookshelf
                                        // in an incremental way

signals:
    void shouldInit();

private:
    int m_sum = 1;
    int m_realSum = 1;
    QHash<int, QString> m_bookIdName {};
    QJsonArray m_bookList = QJsonArray();
    QJsonArray m_readOrder = {1};
    QJsonArray m_joinOrder = {1};
};
