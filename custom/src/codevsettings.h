#ifndef CODEVSETTINGS_H
#define CODEVSETTINGS_H
#include "SettingsGroup.h"

class CodevSettings : public SettingsGroup
{
    Q_OBJECT

public:
    Q_PROPERTY(QString cacheSavePath READ cacheSavePath NOTIFY cacheSavePathChanged)

    CodevSettings(QObject* parent = nullptr);
    DEFINE_SETTING_NAME_GROUP()
    DEFINE_SETTINGFACT(rtcmSource)
    QString cacheSavePath();

    static const char* cacheDirectory;

signals:
    void cacheSavePathChanged();
};

#endif // CODEVSETTINGS_H
