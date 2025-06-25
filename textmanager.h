#pragma once

#include <QObject>
#include <QQmlEngine>

class TextManager : public QObject
{
    Q_OBJECT
    QML_ELEMENT
public:
    explicit TextManager(QObject *parent = nullptr);

    Q_INVOKABLE QString formulaTxt(QList<QString> &txt);

signals:

private:

};
