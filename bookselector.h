#pragma once

#include <QObject>
#include "booklistmanager.h"
#include "readengin.h"

class BookSelector : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QStringList bookList READ bookList NOTIFY bookListChanged)
    Q_PROPERTY(QStringList chapterList READ chapterList NOTIFY chapterListChanged)
    Q_PROPERTY(QString chapterContent READ chapterContent NOTIFY chapterContentChanged)

public:
    explicit BookSelector(QObject *parent = nullptr);

    QStringList bookList() const;
    QStringList chapterList() const;
    QString chapterContent() const;

    Q_INVOKABLE void loadBooks();
    Q_INVOKABLE void selectBook(int index);
    Q_INVOKABLE void selectChapter(int index);

signals:
    void bookListChanged();
    void chapterListChanged();
    void chapterContentChanged();

private:
    BookListManager m_bookListManager;
    ReadEngin m_readEngine;

    QStringList m_books;
    QStringList m_chapters;
    QString m_currentContent;

    int m_currentBookId;
};
