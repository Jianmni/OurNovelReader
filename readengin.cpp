#include "readengin.h"

#include <QDir>

ReadEngin::ReadEngin(QObject *parent)
    : QObject{parent}
{
    m_bookPath += "books/";             // ./books/
}

QList<QVariant> ReadEngin::loadBookReadInfo(int bkId)   // call only once for a book
{
    m_bookPath += tr("%1/").arg(bkId);  // ./books/1/
    QList<QVariant> ret {};

    QString bookInfoPath = m_bookPath + "info.txt";
    QFile info(bookInfoPath);
    if(!info.open(QIODeviceBase::ReadOnly))
    {
        qWarning() << "On ReadEngin::loadBookReadInfo : " + bookInfoPath;
        return ret;
    }
    // get info
    QTextStream in(&info);

    // get content
    while(!in.atEnd())
    {
        QVariant line {};
        line  = in.readLine();
        if(line.isNull()) continue;
        ret.append(line);
    }

    m_tmpForSave = ret;

    return ret;
}

QList<QString> ReadEngin::loadBookContent()
{
    QList<QString> ret {};
    QString bookContentPath = m_bookPath + "content.txt";
    QFile content(bookContentPath);
    if (!content.open(QIODeviceBase::ReadOnly | QIODeviceBase::Text))
    {
        qWarning() << "On ReadEngin::loadBookContent: Open file failed: " + bookContentPath;
        return ret;
    }
    QTextStream in(&content);
    while(!in.atEnd())
    {
        QString line {};
        line = in.readLine();
        if (line.isEmpty()) continue;
        ret.append(line);
    }
    return ret;
}

QList<QString> ReadEngin::loadChapter(int chapterId)
{
    QList<QString> ret {};
    QString chapterPath = tr("%1%2.txt").arg(m_bookPath).arg(chapterId);
    QFile chapter(chapterPath);
    if(!chapter.open(QIODeviceBase::ReadOnly | QIODeviceBase::Text))
    {
        qWarning() << "On ReadEngin::loadChapter: Open file failed: " + chapterPath;
        return ret;
    }
    QTextStream in(&chapter);
    while (!in.atEnd())
    {
        QString line {};
        line = in.readLine();
        if (line.isEmpty()) continue;
        ret.append(line);
    }
    return ret;
}

void ReadEngin::writeProgress(int curContent, int curPage, int hour, int minu, int seco)
{
    QString bookInfoPath = m_bookPath + "info.txt";
    QFile file(bookInfoPath);
    if(!file.open(QIODeviceBase::WriteOnly | QIODeviceBase::Text | QIODeviceBase::Truncate))
    {
        qWarning() << "On ReadEngin::writeProgress: Open file failed: " + bookInfoPath;
    }

    m_tmpForSave[0] = curContent;
    m_tmpForSave[1] = curPage;

    m_tmpForSave[5] = hour;
    m_tmpForSave[6] = minu;
    m_tmpForSave[7] = seco;

    QTextStream out(&file);
    int len = m_tmpForSave.length();
    for (int i=0; i<len; ++i)
        out << m_tmpForSave[i].toString() << '\n';
}
