#include "booklistmanager.h"
#include <QFile>
#include <QJsonDocument>
#include <QDebug>
#include <QDateTime>
#include <QDir>

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
        load();
    }
}

bool BookListManager::initBookList()
{
    QDir dir;
    if (!dir.exists("books"))
    {
        dir.mkdir("books");
        dir.mkdir("books/1");
        QFile note("books/1/0.txt");
        note.open(QIODeviceBase::NewOnly);
    }

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

    QJsonArray order;
    order.append(1);

    obj["bookSum"] = 1;
    obj["bookRealSum"] = 1;
    obj["bookList"] = info;
    obj["readOrder"] = order;
    obj["joinOrder"] = order;
    QJsonDocument doc(obj);

    file.write(doc.toJson());
    m_bookList = info;
    m_sum = 1;
    m_realSum = 1;
    m_readOrder = {1};
    m_joinOrder = {1};
    m_bookIdName.insert(1, "笔记簿");
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
        return true;    // init success
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

    QJsonArray array;
    array = obj["readOrder"].toArray();
    m_readOrder = array;
    array = obj["joinOrder"].toArray();
    m_joinOrder = array;

    for (const auto &val: std::as_const(m_bookList))
    {
        QJsonObject tmp = val.toObject();
        if (tmp["exist"].toBool())
            m_bookIdName.insert(tmp["bookId"].toInt(), tmp["name"].toString());
    }

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
    // qDebug() << "On BookListManager::save(): m_sum: " << m_sum;
    obj["bookRealSum"] = m_realSum;
    obj["bookList"] = m_bookList;
    obj["readOrder"] = m_readOrder;
    obj["joinOrder"] = m_joinOrder;

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

    // update orders
    m_readOrder.append(m_sum);
    m_joinOrder.append(m_sum);

    m_bookIdName.insert(m_sum, name);

    if (!save())
    {
        deleteBook(m_sum);
        return false;
    }
    return true;
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

    // update orders
    QJsonArray tmp = QJsonArray();              // 1,5,4,2,3  2
    for (const auto &val : std::as_const(m_readOrder))
        if(id != val.toInt()) tmp.append(val);  // 1,5,4,3
    m_readOrder = tmp;
    QJsonArray arr = QJsonArray();              // 1,2,3,4,5 2
    for (const auto &val : std::as_const(m_joinOrder))
        if(id != val.toInt()) arr.append(val);  // 1,3,4,5
    m_joinOrder = arr;

    m_bookIdName.remove(id);

    return save();
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

QList<QVariant> BookListManager::getReadOrder()
{
    QList<QVariant> ret {};
    for (const auto &val : std::as_const(m_readOrder))
    {
        ret.append(val.toInt());                        // book id
        ret.append(m_bookIdName.value(val.toInt()));    // book name
        qDebug() << "On BookListManager::getReadOrder : " << val.toInt()
                 << "size: "  << m_readOrder.size();
    }
    return ret;
}

QList<QVariant> BookListManager::getJoinOrder()
{
    QList<QVariant> ret {};
    for (const auto &val : std::as_const(m_joinOrder))
    {
        ret.append(val.toInt());                        // book id
        ret.append(m_bookIdName.value(val.toInt()));    // book name
    }
    return ret;
}

void BookListManager::changeReadOrder(int bookId)
{
    QJsonArray tmp {};
    for (const auto &val: std::as_const(m_readOrder))
    {
        if(val.toInt() == bookId) tmp.append(val);
    }
    tmp.append(bookId);

    m_readOrder = tmp;
    save();
}
