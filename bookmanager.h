// WF 2023051604037
// first complete at 2025/6/19
// manage the opaeration of load local txt
#pragma once
#include <QObject>
#include <QList>
#include <QVariant>

#include "loadtxt.h"
#include "booklistmanager.h"

class BookManager : public QObject {
    Q_OBJECT
public:
    explicit BookManager(QObject *parent = nullptr);

    Q_INVOKABLE void loadLocalFile(const QString &fileUrl);
    // Q_INVOKABLE void loadCover();    // select cover for local book
    Q_INVOKABLE void deleteBook(int id);
    Q_INVOKABLE QList<QVariant> shelfBooksReadOrder();
    Q_INVOKABLE QList<QVariant> shelfBooksJoinOrder();

private:
    void loadTxtFile(const QString &path);

signals:
    void getbookReadOrder();
    void getbookJoinOrder();
    void addFinished();

private:
    LoadTxt m_loadTxt;
    BookListManager m_bookList;
};
