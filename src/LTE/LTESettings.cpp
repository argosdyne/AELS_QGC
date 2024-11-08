#include "LTESettings.h"

DECLARE_SETTINGGROUP(LTE, "LTE")
{
    QQmlEngine::setObjectOwnership(this, QQmlEngine::CppOwnership);
    qmlRegisterUncreatableType<LTESettings>("CustomQmlInterface", 1, 0, "LTESettings", "Reference only");
}

DECLARE_SETTINGSFACT(LTESettings, serverURL)
DECLARE_SETTINGSFACT(LTESettings, username)
DECLARE_SETTINGSFACT(LTESettings, password)
DECLARE_SETTINGSFACT(LTESettings, autoLogin)
