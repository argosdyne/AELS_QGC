#pragma once

#include <QObject>
#include <QAbstractNativeEventFilter>

class RCInterface : public QObject
{
    Q_OBJECT
public:
    RCInterface();
    virtual ~RCInterface() {}
    virtual bool start() = 0;
    virtual void stop() = 0;
    virtual bool isEquel(quint16 vid, quint16 pid) { return false; }
    virtual bool running() { return true; }
    virtual bool enabled() { return true; }

signals:
    void rcChannelValues(const quint16* channels, int count);
    void buttonPressed(int type, bool pressed);
    void runningChanged();
    void enabledChanged();
};

class ThridRCFactory : public QObject, public QAbstractNativeEventFilter
{
    Q_OBJECT
public:
    static ThridRCFactory* instance(void);

    void registerInterfaceFactory(RCInterface* interf);

    Q_PROPERTY(bool running READ running NOTIFY runningChanged)
    Q_PROPERTY(bool enabled READ enabled NOTIFY enabledChanged)
    Q_PROPERTY(bool isHave READ isHave NOTIFY isHaveChanged)

    bool running() { return _currentInterface ? _currentInterface->running() : false; }
    bool enabled() { return _currentInterface ? _currentInterface->enabled() : false; }
    bool isHave() { return _currentInterface ? true : false; }

    // Override from QAbstractNativeEventFilter
    bool nativeEventFilter(const QByteArray &eventType, void *message, long *) override;

public slots:
    void refreshInterface();

signals:
    void rcChannelValuesChanged(const quint16* channels, int count);
    void buttonPressedChanged(int type, bool pressed);
    void request();
    void runningChanged();
    void enabledChanged();
    void isHaveChanged();

private:
    ThridRCFactory();

    QList<RCInterface*> _interfaces;
    RCInterface* _currentInterface{nullptr};

    static ThridRCFactory* _instance;
};

