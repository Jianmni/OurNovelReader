#include "bookmanager.h"
#include <QFile>
#include <QTextStream>
#include <QDir>
#include <qdebug.h>

BookManager::BookManager(QObject *parent)
    : QObject(parent)
{
    // this slot won't be called when finishInit signal emitted
    // connect(&m_bookList, &BookListManager::finishInit, this, &BookManager::loadTestFile);
    m_bookList.load();
    if(m_bookList.isFirstRun()) loadTestFile(); // use this way

    connect(&m_loadTxt, &LoadTxt::shouldInit, &m_bookList, &BookListManager::initBookList);
}

// 添加本地书籍
void BookManager::loadLocalFile(const QString &fileUrl) {
    QString path = fileUrl;
    path.remove(0,8);   // remove file:///

    // check file type: txt, pdf, doc
    int dotPos = path.lastIndexOf('.');
    QString type = path.last(path.length() - dotPos - 1);
    qDebug() << "Book Type: " << type;

    if (type == "txt") // load txt
        loadTxtFile(path);
    // else if (type == "pdf") // load pdf
}

// 删除书籍
// 将BookList.json中的存在设为false，实际数量减一，改变排序
// 删除保存的正文文本
void BookManager::deleteBook(int id)
{
    m_bookList.deleteBook(id);
    m_loadTxt.deleteBook(id);
}

// 获取数据阅读顺序
// 送给书架Shelf
QList<QVariant> BookManager::shelfBooksReadOrder()
{
    return m_bookList.getReadOrder();
}

// 获取书籍的加入顺序
// 送给书架Shelf
QList<QVariant> BookManager::shelfBooksJoinOrder()
{
    return m_bookList.getJoinOrder();
}

// 导入本地书籍
// 2025-7-8： 目前仅实现一种格式的导入。文本从网站http://www.shukuge.com/下载
void BookManager::loadTxtFile(const QString &path)
{
    int id = m_bookList.bookSum();
    if (!m_loadTxt.loadLocalBook(path, id+1))
        return;

    // book name                                    // .../download/Love.txt
    QString bkname = "未知书籍";
    int ltcolon = path.lastIndexOf('/');
    bkname = path.last(path.length() - ltcolon-1);  // Love.txt
    int ltdot = bkname.lastIndexOf(".");
    bkname = bkname.first(ltdot);                   // Love

    // qDebug() << "On BookManager::loadTxtFile : bkname: "<< bkname;
    m_bookList.addBook(bkname);

    // load cover img

    emit addFinished();
}

void BookManager::loadTestFile()
{
    // qWarning() << "Ok Init";
    loadTxtFile(":/novel/testFile/武动乾坤.txt");
}
