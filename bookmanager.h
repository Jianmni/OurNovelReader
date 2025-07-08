// WF 2023051604037
// 2025-6-19 -- 2025-7-8
// manage the opaeration of load local txt
// 书籍管理，管理书籍的添加、删除、信息读取
#pragma once
#include <QObject>
#include <QList>
#include <QVariant>
#include <QtQml/qqmlregistration.h>

#include "loadtxt.h"
#include "booklistmanager.h"

class BookManager : public QObject {
    Q_OBJECT
    QML_ELEMENT
public:
    explicit BookManager(QObject *parent = nullptr);

    Q_INVOKABLE void loadLocalFile(const QString &fileUrl);
    // Q_INVOKABLE void loadCover();    // select cover for local book
    Q_INVOKABLE void deleteBook(int id);
    Q_INVOKABLE QList<QVariant> shelfBooksReadOrder();
    Q_INVOKABLE QList<QVariant> shelfBooksJoinOrder();

private:
    void loadTxtFile(const QString &path);
    void loadTestFile();

signals:
    void getbookReadOrder();
    void getbookJoinOrder();
    void addFinished();

private:
    LoadTxt m_loadTxt;
    BookListManager m_bookList;
};
