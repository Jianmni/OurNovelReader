#include "AndroidPermission.h"
#include <QtCore/private/qandroidextras_p.h>
#include <QJniObject>

AndroidPermission::AndroidPermission(QObject *parent) : QObject(parent)
{
}

bool AndroidPermission::checkPermission(const QString &permission)
{
    return checkPermissionInternal(permission);
}

void AndroidPermission::requestPermission(const QString &permission)
{
    requestPermissionInternal(permission);
}

void AndroidPermission::requestPermissions(const QStringList &permissions)
{
    for (const QString &permission : permissions) {
        requestPermissionInternal(permission);
    }
}

bool AndroidPermission::checkPermissionInternal(const QString &permission)
{
    QJniObject context = QNativeInterface::QAndroidApplication::context();
    if (!context.isValid())
        return false;

    int result = QJniObject::callStaticMethod<jint>(
        "android/content/pm/PackageManager",
        "PERMISSION_GRANTED",
        "()I"
        );

    QJniEnvironment env;
    jint checkResult = QJniObject::callStaticMethod<jint>(
        "androidx/core/content/ContextCompat",
        "checkSelfPermission",
        "(Landroid/content/Context;Ljava/lang/String;)I",
        context.object(),
        QJniObject::fromString(permission).object()
        );

    return checkResult == result;
}

void AndroidPermission::requestPermissionInternal(const QString &permission)
{
    QJniObject activity = QNativeInterface::QAndroidApplication::context();
    if (!activity.isValid())
        return;

    QJniObject permissionObj = QJniObject::fromString(permission);
    jint requestCode = 0; // 可以根据需要设置请求码

    QJniObject::callStaticMethod<void>(
        "androidx/core/app/ActivityCompat",
        "requestPermissions",
        "(Landroid/app/Activity;[Ljava/lang/String;I)V",
        activity.object(),
        QJniObject::fromString(permission).object<jarray>(),
        requestCode
        );
}
