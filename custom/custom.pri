message("Adding Custom Plugin")

#-- Version control
#   Major and minor versions are defined here (manually)

CUSTOM_QGC_VER_MAJOR = 0
CUSTOM_QGC_VER_MINOR = 0
CUSTOM_QGC_VER_FIRST_BUILD = 0

# Build number is automatic
# Uses the current branch. This way it works on any branch including build-server's PR branches
CUSTOM_QGC_VER_BUILD = $$system(git --git-dir ../.git rev-list $$GIT_BRANCH --first-parent --count)
win32 {
    CUSTOM_QGC_VER_BUILD = $$system("set /a $$CUSTOM_QGC_VER_BUILD - $$CUSTOM_QGC_VER_FIRST_BUILD")
} else {
    CUSTOM_QGC_VER_BUILD = $$system("echo $(($$CUSTOM_QGC_VER_BUILD - $$CUSTOM_QGC_VER_FIRST_BUILD))")
}
# CUSTOM_QGC_VERSION = $${CUSTOM_QGC_VER_MAJOR}.$${CUSTOM_QGC_VER_MINOR}.$${CUSTOM_QGC_VER_BUILD}
CUSTOM_QGC_VERSION = $${CUSTOM_QGC_VER_MAJOR}.$${CUSTOM_QGC_VER_MINOR}.1


DEFINES -= APP_VERSION_STR=\"\\\"$$APP_VERSION_STR\\\"\"
DEFINES += APP_VERSION_STR=\"\\\"$$CUSTOM_QGC_VERSION\\\"\"

message(Custom QGC Version: $${CUSTOM_QGC_VERSION})

# # Build a single flight stack by disabling APM support
# MAVLINK_CONF = all
# CONFIG  += QGC_DISABLE_APM_MAVLINK # THANH: Check
CONFIG  += QGC_DISABLE_PX4_PLUGIN QGC_DISABLE_PX4_PLUGIN_FACTORY

# We implement our own PX4 plugin factory
CONFIG  += QGC_DISABLE_APM_PLUGIN_FACTORY

# Branding

DEFINES += CUSTOMHEADER=\"\\\"CustomPlugin.h\\\"\"
DEFINES += CUSTOMCLASS=CustomPlugin

TARGET   = CustomQGroundControl
DEFINES += QGC_APPLICATION_NAME='"\\\"Custom QGroundControl\\\""'

DEFINES += QGC_ORG_NAME=\"\\\"argosdyne.org\\\"\"
DEFINES += QGC_ORG_DOMAIN=\"\\\"org.argosdyne\\\"\"

QGC_APP_NAME        = "Custom QGroundControl"
QGC_BINARY_NAME     = "CustomQGroundControl"
QGC_ORG_NAME        = "Custom"
QGC_ORG_DOMAIN      = "org.custom"
QGC_ANDROID_PACKAGE = "org.custom.qgroundcontrol"
QGC_APP_DESCRIPTION = "Custom QGroundControl"
QGC_APP_COPYRIGHT   = "Copyright (C) 2020 QGroundControl Development Team. All rights reserved."

# Our own, custom resources
RESOURCES += \
    $$PWD/custom.qrc

QML_IMPORT_PATH += \
   $$PWD/res

# Our own, custom sources
SOURCES += \
    $$PWD/src/CustomPlugin.cc \
    $$PWD/src/RTCM/CodevRTCMManager.cpp \
    $$PWD/src/RTCM/NTRIPRTCMSource.cpp \
    $$PWD/src/RTCM/RTCMBase.cpp \
    $$PWD/src/RTCM/SerialPortRTCMSource.cpp \
    $$PWD/src/SiYi/SiYiCamera.cc \
    $$PWD/src/SiYi/SiYiCrcApi.cc \
    $$PWD/src/SiYi/SiYiManager.cc \
    $$PWD/src/SiYi/SiYiTcpClient.cc \
    $$PWD/src/SiYi/SiYiTransmitter.cc \
    $$PWD/src/codevsettings.cpp \ 
    $$PWD/src/AVIATOR/AVIATORInterface.cpp \
    $$PWD/src/thridRC/FortInterface.cpp \ 
    $$PWD/src/thridRC/T30Interface.cpp \ 
    $$PWD/src/thridRC/ThridRCFactory.cpp \ 
    $$PWD/src/CustomQmlInterface.cc \
    $$PWD/src/ARLink/ARConnection.cpp \
    $$PWD/src/ARLink/ARManager.cpp \
    $$PWD/src/CustomSettings.cc


HEADERS += \
    $$PWD/src/CustomPlugin.h \
    $$PWD/src/RTCM/CodevRTCMManager.h \
    $$PWD/src/RTCM/NTRIPRTCMSource.h \
    $$PWD/src/RTCM/RTCMBase.h \
    $$PWD/src/RTCM/SerialPortRTCMSource.h \
    $$PWD/src/SiYi/SiYiCamera.h \
    $$PWD/src/SiYi/SiYiCrcApi.h \
    $$PWD/src/SiYi/SiYiManager.h \
    $$PWD/src/SiYi/SiYiTcpClient.h \
    $$PWD/src/SiYi/SiYiTransmitter.h \
    $$PWD/src/codevsettings.h \
    $$PWD/src/lockedqueue.h \
    $$PWD/src/AVIATOR/AVIATORInterface.h \
    $$PWD/src/thridRC/FortInterface.h \
    $$PWD/src/thridRC/T30Interface.h \
    $$PWD/src/thridRC/ThridRCFactory.h \
    $$PWD/src/CustomQmlInterface.h \
    $$PWD/src/ARLink/ARConnection.h \
    $$PWD/src/ARLink/ARManager.h \
    $$PWD/src/CustomSettings.h


INCLUDEPATH += \
    $$PWD/src \
    $$PWD/src/SiYi/ \
    $$PWD/src/RTCM/ \
    $$PWD/src/AVIATOR \
    $$PWD/src/thridRC \
    $$PWD/src/ARLink \

#-------------------------------------------------------------------------------------
# Custom Firmware/AutoPilot Plugin

INCLUDEPATH += \
    $$PWD/src/FirmwarePlugin \
    $$PWD/src/AutoPilotPlugin
    $$PWD/src/FirmwarePlugin/APM/

HEADERS+= \
    $$PWD/src/AutoPilotPlugin/CustomAutoPilotPlugin.h \
    $$PWD/src/FirmwarePlugin/CustomFirmwarePlugin.h \
    $$PWD/src/FirmwarePlugin/CustomFirmwarePluginFactory.h \
    

SOURCES += \
    $$PWD/src/AutoPilotPlugin/CustomAutoPilotPlugin.cc \
    $$PWD/src/FirmwarePlugin/CustomFirmwarePlugin.cc \
    $$PWD/src/FirmwarePlugin/CustomFirmwarePluginFactory.cc \
    

