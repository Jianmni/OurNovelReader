#include "booklistmanager.h"
#include <QFile>
#include <QJsonDocument>
#include <QDebug>
#include <QDateTime>

BookListManager::BookListManager(QObject *parent)
    : QObject(parent)
{
    // init when constructed
    QFile file("books/booklist.json");
    if (!file.open(QIODevice::ReadOnly)) {  // create failed: file does not exist
        initBookList();
    }
    else
    {
        QByteArray data = file.readAll();
        QJsonDocument doc(QJsonDocument::fromJson(data));

        if (doc.isNull()) {
            qWarning() << "On load: Parse JSON failed";
            return;
        }

        QJsonObject obj = doc.object();

        m_sum = obj["bookSum"].toInt();
        m_realSum = obj["bookRealSum"].toInt();
        m_bookList = obj["bookList"].toArray();
    }
}

bool BookListManager::initBookList()
{
    QFile file("books/booklist.json");
    if (!file.open(QIODevice::NewOnly)) {
        qWarning() << "On init: File open failed: books/booklist.json exists";
        return false;
    }

    QJsonObject obj;
    QJsonArray info;

    QJsonObject newBook;
    newBook["bookId"] = 1;
    newBook["name"] = "笔记簿";
    newBook["exist"] = true;
    newBook["progress"] = 0;
    newBook["readTime"] = 0;
    QDateTime dt = QDateTime::currentDateTime();
    newBook["joinDate"] = dt.toString("yyyy-MM-dd");
    newBook["joinTime"] = dt.toString("HH-mm-ss");

    info.append(newBook);

    obj["bookSum"] = 1;
    obj["bookRealSum"] = 1;
    obj["bookList"] = info;
    QJsonDocument doc(obj);

    file.write(doc.toJson());
    m_bookList = info;
    m_sum = 1;
    m_realSum = 1;
    return true;
}

// get info from json file
bool BookListManager::load() {
    QFile file("books/booklist.json");
    if (!file.open(QIODevice::ReadOnly)) {
        if (!initBookList())
        {
            qWarning() << "On load: File open failed: books/booklist.json";
            return false;
        }
    }

    QByteArray data = file.readAll();
    QJsonDocument doc(QJsonDocument::fromJson(data));

    if (doc.isNull()) {
        qWarning() << "On load: Parse JSON failed";
        return false;
    }

    QJsonObject obj = doc.object();

    m_sum = obj["bookSum"].toInt();
    m_realSum = obj["bookRealSum"].toInt();
    m_bookList = obj["bookList"].toArray();

    return true;
}

// write changes to json file
bool BookListManager::save() {
    QFile file("books/booklist.json");
    if (!file.open(QIODevice::WriteOnly)) {
        qWarning() << "On save: File open failed: books/booklist.json";
        return false;
    }

    QJsonObject obj;
    obj["bookSum"] = m_sum;
    qDebug() << "On BookListManager::save(): m_sum: " << m_sum;
    obj["bookRealSum"] = m_realSum;
    obj["bookList"] = m_bookList;

    QJsonDocument doc(obj);
    file.write(doc.toJson());
    return true;
}


bool BookListManager::addBook(const QString &name) {
    // 创建新书籍对象
    QJsonObject newBook;
    newBook["id"] = m_sum + 1;
    newBook["name"] = name;
    newBook["exist"] = true;
    newBook["progress"] = 0;
    newBook["readTime"] = 0;

    QDateTime dt = QDateTime::currentDateTime();
    newBook["joinDate"] = dt.toString("yyyy-MM-dd");
    newBook["joinTime"] = dt.toString("HH-mm-ss");

    // 添加到数组
    m_bookList.append(newBook);

    // 更新总数
    m_sum++;
    m_realSum++;

    return save();
}

bool BookListManager::deleteBook(int id)
{
    int pos = getBookPos(id);
    if (pos == -1 || pos == 0) return false;    // 笔记簿不能删除
    QJsonValue val = m_bookList[pos];

    QJsonObject target = val.toObject();

    target["exist"] = false;
    m_bookList.replace(pos, target);
    m_realSum--;
    return true;
}

int BookListManager::getBookPos(int id) const {
    int pos = 0;
    for (auto &value : m_bookList)
    {
        QJsonObject obj = value.toObject();
        if (obj["id"].toInt() == id)
            return pos;
        pos++;
    }
    return -1;
}
