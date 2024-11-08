#pragma once

#include "SettingsGroup.h"

class LTESettings : public SettingsGroup
{
    Q_OBJECT
public:
    LTESettings(QObject* parent = nullptr);

    DEFINE_SETTING_NAME_GROUP()

    DEFINE_SETTINGFACT(serverURL)
    DEFINE_SETTINGFACT(username)
    DEFINE_SETTINGFACT(password)
    DEFINE_SETTINGFACT(autoLogin)
};
