#pragma once

#include <QObject>
#include <QtQml/qqmlregistration.h>

class AndroidPermission : public QObject
{
    Q_OBJECT
    QML_ELEMENT
public:
    explicit AndroidPermission(QObject *parent = nullptr);

    Q_INVOKABLE bool checkPermission(const QString &permission);
    Q_INVOKABLE void requestPermission(const QString &permission);
    Q_INVOKABLE void requestPermissions(const QStringList &permissions);

signals:
    void permissionGranted(const QString &permission);
    void permissionDenied(const QString &permission);

private:
    bool checkPermissionInternal(const QString &permission);
    void requestPermissionInternal(const QString &permission);
};
