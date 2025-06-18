#include "bookmanager.h"
#include <QFile>
#include <QTextStream>
#include <QDir>
#include <qdebug.h>

BookManager::BookManager(QObject *parent)
    : QObject(parent)
{
    if (m_bookList.load())
    {
        QDir dir;
        dir.mkdir("books/1");
        QFile note("books/1/0.txt");
        note.open(QIODeviceBase::NewOnly);
        // copy init info in Qt src
    }
    connect(&m_loadTxt, &LoadTxt::shouldInit, &m_bookList, &BookListManager::initBookList);
}

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

void BookManager::loadTxtFile(const QString &path)
{
    int id = m_bookList.bookSum();
    if (!m_loadTxt.loadLocalBook(path, id+1))
    {
        return;
    }

    // book name                                    // .../download/Love.txt
    QString bkname = "佚名";
    int ltcolon = path.lastIndexOf('/');
    bkname = path.last(path.length() - ltcolon-1);  // Love.txt
    int ltdot = bkname.lastIndexOf(".");
    bkname = bkname.first(ltdot);                   // Love

    // qDebug() << "On BookManager::loadTxtFile : bkname: "<< bkname;
    m_bookList.addBook(bkname);

    // load cover img

    emit addFinished();
}
