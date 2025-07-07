#pragma once

#include <QObject>
#include <QtQml/qqmlregistration.h>

class TextManager : public QObject
{
    Q_OBJECT
    QML_ELEMENT
public:
    explicit TextManager(QObject *parent = nullptr);

    Q_INVOKABLE QList<QString> formulaTxt(QList<QString> txt);
    Q_INVOKABLE void changeInfo(int cn, int tc);

    QList<QString> processTitle(QString title);
    QList<QString> processLine(QString line);

signals:

private:
    int m_charNum = 0;      // num of chars in one line
    int m_ttChNum = 0;      // num of chars in one line of title
};
