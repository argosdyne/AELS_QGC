#include "codevsettings.h"
#include <QQmlEngine>
#include <QtQml>
#include <QVariantList>
#include "QGCApplication.h"
#include "SettingsManager.h"
#include "AppSettings.h"

const char* CodevSettings::cacheDirectory = "Cache";

DECLARE_SETTINGGROUP(Codev, "Codev")
{
    QQmlEngine::setObjectOwnership(this, QQmlEngine::CppOwnership);
    qmlRegisterUncreatableType<CodevSettings>("CustomQuickInterface", 1, 0, "CodevSettings", "Reference only");
    connect(qgcApp()->toolbox()->settingsManager()->appSettings(), &AppSettings::savePathsChanged,
            this, &CodevSettings::cacheSavePathChanged);
}


QString CodevSettings::cacheSavePath(void)
{
    QString path = qgcApp()->toolbox()->settingsManager()->appSettings()->savePath()->rawValue().toString();
    if (!path.isEmpty() && QDir(path).exists()) {
        QDir dir(path);
        dir.mkdir(cacheDirectory);
        return dir.filePath(cacheDirectory);
    }
    return QString();
}

DECLARE_SETTINGSFACT(CodevSettings, rtcmSource)
