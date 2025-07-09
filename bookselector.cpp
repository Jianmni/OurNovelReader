#include "bookselector.h"
#include <QDebug>

BookSelector::BookSelector(QObject *parent) : QObject(parent)
{
    loadBooks();
}

QStringList BookSelector::bookList() const
{
    return m_books;
}

QStringList BookSelector::chapterList() const
{
    return m_chapters;
}

QString BookSelector::chapterContent() const
{
    return m_currentContent;
}

void BookSelector::loadBooks()
{
    m_books.clear();
    QList<QVariant> books = m_bookListManager.getReadOrder();

    for (int i = 0; i < books.size(); i += 2) {
        int bookId = books[i].toInt();
        QString bookName = books[i+1].toString();
        m_books.append(QString("%1. %2").arg(bookId).arg(bookName));
    }

    emit bookListChanged();
}

void BookSelector::selectBook(int index)
{
    if (index < 0 || index >= m_books.size()) return;

    QList<QVariant> books = m_bookListManager.getReadOrder();
    m_currentBookId = books[index*2].toInt();

    // Load chapters for this book
    m_chapters.clear();
    QList<QString> chapters = m_readEngine.loadBookContent();
    for (const QString &chapter : chapters) {
        m_chapters.append(chapter);
    }

    emit chapterListChanged();
}

void BookSelector::selectChapter(int index)
{
    if (index < 0 || index >= m_chapters.size()) return;

    // Load chapter content (index+1 because chapters start from 1)
    QList<QString> content = m_readEngine.loadChapter(index + 1);
    m_currentContent = content.join("\n");

    emit chapterContentChanged();
}
