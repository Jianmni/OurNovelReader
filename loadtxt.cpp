#include "loadtxt.h"
#include <QFile>
#include <QDir>

LoadTxt::LoadTxt(QObject *parent) : QObject(parent)
{}

bool LoadTxt::loadLocalBook(const QString &filepath, int id)
{
    /* prepare  */
    m_chapterCount = 0;
    m_bookDir = tr("books/%1/").arg(id); // ./books/20 dir
    qDebug() << m_bookDir;
    m_content.clear();

    // create files to store txt info and context
    createFiles();

    return processText(filepath);
}

void LoadTxt::createFiles()
{
    QDir cur(".");
    if (!cur.exists("books"))
    {
        cur.mkdir("books");
        emit shouldInit();  // let book list manager create booklist.json
    }

    cur.mkdir(m_bookDir);
    qDebug() << "On LoadTxt createFiles: mkdir";
    QFile first(m_bookDir+"0.txt");
    first.open(QIODeviceBase::NewOnly);
}

bool LoadTxt::processText(const QString& filepath)
{
    QFile text(filepath);
    if (!text.open(QIODeviceBase::ReadOnly | QIODeviceBase::Text))
    {
        qWarning() << "On LoadTxt processTxt: File open failed: " + filepath;
        emit loadFailed();
        deleteAll();
        return false;
    }
    QTextStream in(&text);

    QString title;          //   title of a chapter

    // find first titel
    int count = 0;
    while (!in.atEnd() && count < 100)
    {
        count++;
        QString line = in.readLine();
        if (line.isEmpty()) continue;

        if (line.first(1) != "第" && line.first(1) != "前")  continue; // 第一章， 前言
        else if (line.length() > 30) continue;

        m_chapterCount++;
        int spacePos = line.lastIndexOf(" ");
        title = line.last(line.length() - spacePos);
        title = tr("第%1章 %2").arg(m_chapterCount).arg(title);

        break;
    }

    // 这本书很可能没有章节划分
    // this book propably has no chapters
    if (count == 100)
    {
        qDebug() << "On LoadTxt processTxt:(count == 100): " << (count == 100);
        emit loadFailed();
        deleteAll();
        return false;
    }

    qDebug() << "On LoadTxt processTxt: Find first title: " << title;

    // process line by line
    QStringList context;    // context of a chapter
    // count = 0;
    while(!in.atEnd())
    {
        QString line = in.readLine() ;
        if (line.isEmpty()) continue;

        if (line.length()>4 &&  line.last(4) == "---") continue;
        else if (line.first(1) == "第")
        {
            if (line.length() > 24) continue;

            // write context to file
            if (!writeChapter(context, title)) {
                deleteAll();
                emit loadFailed();
                return false;
            }
            context.clear();        // clear for next chapter

            // next chapter
            m_chapterCount++;
            int spacePos = line.lastIndexOf(" ");
            title = line.last(line.length() - spacePos);
            title = tr("第%1章 %2").arg(m_chapterCount).arg(title);
        }
        else    // true line of context
        {
            QString pure = line.remove(' ');
            context.append(pure);
        }
        // qDebug() << "On LoadTxt processText: Line: " << count;
        // count++;
    }
    if (!context.isEmpty())
        if (!writeChapter(context, title)) {
            deleteAll();
            emit loadFailed();
            return false;
        }

    // write content
    QFile ctt(m_bookDir + "0.txt");
    if (!ctt.open(QIODevice::WriteOnly))
    {
        deleteAll();
        emit loadFailed();
        return false;
    }
    QTextStream out(&ctt);
    for (auto &item: m_content)
        out << item << '\n';

    emit loadComplete();
    return true;
}

bool LoadTxt::writeChapter(const QStringList &context, const QString &title)
{
    QString last = tr("%1%2.txt").arg(m_bookDir).arg(m_chapterCount);
    QFile lastChapter(last);
    if (!lastChapter.open(QIODeviceBase::NewOnly | QIODeviceBase::ReadWrite))
    {
        qWarning() << "On LoadTxt writeChapter: Error happened. Load stopped.";
        emit loadFailed();
        return false;
    }
    // write
    QTextStream out(&lastChapter);
    out << title << '\n';
    for (const auto &line : context)
        out << line << '\n';

    lastChapter.close();
    m_content.append(title);
    return true;
}

void LoadTxt::deleteAll()
{
    QDir dir(m_bookDir);
    QStringList files = dir.entryList();
    for (auto &file: files)
    {
        QString path = m_bookDir + file;
        QFile::remove(path);
    }
    dir.cdUp();
    dir.rmdir(m_bookDir);
}
