#include "NTRIPRTCMSource.h"
QGC_LOGGING_CATEGORY(NTRIPRTCMSourceLog, "NTRIPRTCMSourceLog")
#include <iostream>
#include <fstream>
#include <QtNetwork>
#include <QStandardPaths>
NTRIPRTCMSource::NTRIPRTCMSource(QObject* parent)
    : RTCMBase ("NTRIPRTCM", parent)
    , _tcpSocket(new QTcpSocket(this))
{
    connect(_tcpSocket, SIGNAL(connected()), this, SLOT(_onSocketConnected()));
    connect(_tcpSocket, SIGNAL(disconnected()), this, SLOT(_onSocketDisconnected()));
    connect(_tcpSocket, SIGNAL(error(QAbstractSocket::SocketError)), this, SLOT(_onSocketError(QAbstractSocket::SocketError)));
    connect(_tcpSocket, SIGNAL(readyRead()), this, SLOT(_onSocketReplied()));

    Fact* autoGPGGA = autoUpdateGPGGA();
    if(autoGPGGA->rawValue().toBool()) {
        connect(this, &NTRIPRTCMSource::pgggaMessageChanged, gpggamessage(), &Fact::setRawValue);
    } else {
        disconnect(this, &NTRIPRTCMSource::pgggaMessageChanged, gpggamessage(), &Fact::setRawValue);
    }
    connect(autoGPGGA, &Fact::rawValueChanged, this, [this](QVariant value){
        if(value.toBool()) {
            connect(this, &NTRIPRTCMSource::pgggaMessageChanged, gpggamessage(), &Fact::setRawValue);
        } else {
            disconnect(this, &NTRIPRTCMSource::pgggaMessageChanged, gpggamessage(), &Fact::setRawValue);
        }
    });

    Fact* gpggaHz = gpggamessageHz();
    connect(&_sendGPGGATimer, &QTimer::timeout, this, &NTRIPRTCMSource::_handle_send_gpgga_time_out);
    _sendGPGGATimer.setInterval(gpggaHz->rawValue().toInt());
    connect(gpggaHz, &Fact::rawValueChanged, this, [this](QVariant value){
        _sendGPGGATimer.setInterval(value.toInt());
        if(_sendGPGGATimer.isActive()) {
            _sendGPGGATimer.stop();
            _sendGPGGATimer.start();
        }
    });
}

NTRIPRTCMSource::~NTRIPRTCMSource()
{

}

//Ntrip caster Source Code 
#if true
size_t writeData(void* ptr, size_t size, size_t nmemb, FILE* stream) {
    return fwrite(ptr, size, nmemb, stream);
}
QString getExternalStoragePath() {
    // Get the directory for storing external files.
    return QStandardPaths::writableLocation(QStandardPaths::DownloadLocation);
}
void NTRIPRTCMSource::get_caster_xml() {
#ifdef Q_OS_ANDROID
	// 안드로이드 환경에서 실행될 코드
	QString filePath = getExternalStoragePath() + "/rtk_data.xml";
	qCDebug(NTRIPRTCMSourceLog) << "Android File Path : " << filePath;
#else
	// 윈도우 환경에서 실행될 코드
	QString filePath = "rtk_data.xml";
#endif

	QUrl url("http://igs-ip.net:2101/");
	qCDebug(NTRIPRTCMSourceLog) << "get caster xml : " << url;
	QNetworkAccessManager manager;
    QNetworkRequest request(url);
    request.setRawHeader("Authorization", "Basic " + QByteArray("MP16804:746zew").toBase64());
    QNetworkReply* reply = manager.get(request);

    QEventLoop loop;
    QObject::connect(reply, &QNetworkReply::finished, &loop, &QEventLoop::quit);
    loop.exec();

    if (reply->error() != QNetworkReply::NoError) {
        std::cerr << "Failed to retrieve RTK data. Error: " << reply->errorString().toStdString() << std::endl;
        qCDebug(NTRIPRTCMSourceLog) << "Failed to retrieve RTK data. Error";
    }
    else {
        QFile file(filePath);
        if (file.open(QIODevice::WriteOnly)) {
            file.write(reply->readAll());
            file.close();
            std::cout << "RTK data received and saved to: " << filePath.toStdString() << std::endl;
            qCDebug(NTRIPRTCMSourceLog) << "RTK data received and saved to: ";
        }
        else {
            std::cerr << "Failed to open file for writing: " << filePath.toStdString() << std::endl;
            qCDebug(NTRIPRTCMSourceLog) << "Failed to open file for writing: ";
        }
    }

    reply->deleteLater();
}
#endif

void NTRIPRTCMSource::_handle_send_gpgga_time_out()
{
    if(_tcpSocket->isOpen() && _tcpSocket->isValid() && _tcpSocket->isWritable()) {
        if(gpggamessage()->rawValueString().isEmpty()) {
            QString test_message = QString("$GPGGA,%1,3080.7144,N,12134.3847,E,1,04,24.4,19.7,M,1,M,,*").arg(QDateTime::currentDateTimeUtc().toString("hhmmss.zzz"));
            QByteArray array = test_message.toLatin1();
            uint8_t result = static_cast<uint8_t>(array.at(1));
            for(int i = 2; array.at(i) != '*'; i++) {
                result ^= static_cast<uint8_t>(array.at(i));
            }
            QString res_str = QString::number(result, 16);
            test_message.append(res_str.count() == 2 ? res_str : '0' + res_str);
            qCDebug(NTRIPRTCMSourceLog) << "Send GPGGA:" << test_message;
            test_message.append("\r\n");
            _tcpSocket->write(test_message.toUtf8());
        } else {
            QString message = gpggamessage()->rawValueString();
            message.append("\r\n");
            _tcpSocket->write(message.toUtf8());
            qCDebug(NTRIPRTCMSourceLog) << "Send GPGGA:" << message;
        }
    }
}

void NTRIPRTCMSource::refreshMountPoint()
{
    QTcpSocket* _socket = new QTcpSocket();
    connect(_socket, &QTcpSocket::connected, this, [_socket](){
        static QString request = QString("GET / HTTP/1.1\r\n"
                                 "User-Agent: NTRIPSource/v1.0\r\n"
                                 "Connection: close\r\n"
                                 "\r\n");

        qCDebug(NTRIPRTCMSourceLog) << "Request mount point source table.";
        _socket->write(request.toUtf8());
    });
    connect(_socket, &QTcpSocket::readyRead, this, [this, _socket](){
        QString ok = QString(_socket->readLine());
        if(ok.contains("SOURCETABLE 200 OK")) {
            QStringList enumStrings;
            QVariantList enumValues;
            enumStrings.append("AUTO");
            enumValues.append("AUTO");
            while (!_socket->atEnd()) {
                QString line = _socket->readLine();
                QStringList parameters = line.split(";");
                if(parameters.size() < 2) continue;
                if(parameters.at(0) == "STR" || parameters.at(0) == "CAS" || parameters.at(0) == "NET") {
                    enumStrings.append(parameters.at(1));
                    enumValues.append(parameters.at(1));
                    qCDebug(NTRIPRTCMSourceLog) << QString("Found %1:%2 mount point.").arg(parameters.at(0)).arg(parameters.at(1));
                }
            }
            mountpoint()->setEnumInfo(enumStrings, enumValues);
            emit mountpoint()->enumsChanged();
        }
        _socket->disconnectFromHost();
    });
    _socket->connectToHost(host()->rawValueString(), static_cast<quint16>(port()->rawValue().toInt()));
    connect(_socket, &QTcpSocket::disconnected, _socket, [_socket](){
        qCDebug(NTRIPRTCMSourceLog) << "Finish refreshing mount point.";
        _socket->deleteLater();
    });

    // connect(_socket, QOverload<QAbstractSocket::SocketError>::of(&QAbstractSocket::error), this, [_socket](QAbstractSocket::SocketError error){
    //     qCDebug(NTRIPRTCMSourceLog) << "Refresh mount point error: " << error;
    //     _socket->deleteLater();
    // });

    connect(_socket, &QTcpSocket::errorOccurred, this, [_socket](QAbstractSocket::SocketError error){
        qCDebug(NTRIPRTCMSourceLog) << "Refresh mount point error: " << error;
        _socket->deleteLater();
    });
}

void NTRIPRTCMSource::getFromVehicle()
{
    gpggamessage()->setRawValue(_gpggaFromVehicle);
}

void NTRIPRTCMSource::logIn()
{
    qCDebug(NTRIPRTCMSourceLog) << "Log In...";
    setIsLogIning(true);
    _tcpSocket->connectToHost(host()->rawValueString(), static_cast<quint16>(port()->rawValue().toInt()));
}

void NTRIPRTCMSource::logOut()
{
    qCDebug(NTRIPRTCMSourceLog) << "Log Out";
    _tcpSocket->close();
}

void NTRIPRTCMSource::_onSocketConnected()
{
    QString userinfo_raw = QString("%1:%2").arg(user()->rawValueString()).arg(passwd()->rawValueString());
    QString userinfo = QString(userinfo_raw.toLatin1().toBase64());
    QString request = QString("GET /%1 HTTP/1.1\r\n"
                   "User-Agent: NTRIPSource/v1.0\r\n"
                   "Accept: */*\r\n"
                   "Connection: close\r\n"
                   "Authorization: Basic %2\r\n"
                   "\r\n").arg(mountpoint()->rawValue().toString()).arg(userinfo);

     _tcpSocket->write(request.toUtf8());
    qCDebug(NTRIPRTCMSourceLog) << "Authorization...\n\r" << request;
}

void NTRIPRTCMSource::_onSocketReplied()
{
    QByteArray data = _tcpSocket->readAll();
    if(data.contains("ICY 200 OK")) {
        setIsLogIning(false);
        setIsLogIn(true);
        if(_sendGPGGATimer.isActive()) {
            _sendGPGGATimer.stop();
        }
        _sendGPGGATimer.start();
        _handle_send_gpgga_time_out();
    } else if(data.contains("Unauthorized")) {
        _sendGPGGATimer.stop();
        setIsLogIning(false);
        setIsLogIn(false);
    }

    if(static_cast<uint8_t>(data.at(0)) == 0xd3 && static_cast<uint8_t>(data.at(1)) == 0x00) {
        if(isLogIn()) {
            if(_work_queue.size() == 0) {
                send_rtcm_package(data.data(), static_cast<unsigned>(data.size()));
            } else {
                qCWarning(NTRIPRTCMSourceLog) << "Send RTCM: Busy. You can improve RTCM transmission rate.";
            }
        }
        qCDebug(NTRIPRTCMSourceLog) << QString("Socket Replied: RTCM Data(size: %1 bytes)").arg(data.size());
    } else {
        qCDebug(NTRIPRTCMSourceLog) << QString("Socket Replied: \n\r%1").arg(QString(data));
    }
}

void NTRIPRTCMSource::_onSocketError(QAbstractSocket::SocketError error)
{
    _sendGPGGATimer.stop();
    qCDebug(NTRIPRTCMSourceLog) << QString("Socket Error:") << error;
    _tcpSocket->close();
    setIsLogIn(false);
    setIsLogIning(false);
}

void NTRIPRTCMSource::_onSocketDisconnected()
{
    _sendGPGGATimer.stop();
    setIsLogIn(false);
    setIsLogIning(false);
}

DECLARE_SETTINGSFACT(NTRIPRTCMSource, host)
DECLARE_SETTINGSFACT(NTRIPRTCMSource, port)
DECLARE_SETTINGSFACT(NTRIPRTCMSource, user)
DECLARE_SETTINGSFACT(NTRIPRTCMSource, passwd)
DECLARE_SETTINGSFACT(NTRIPRTCMSource, gpggamessage)
DECLARE_SETTINGSFACT(NTRIPRTCMSource, autoUpdateGPGGA)
DECLARE_SETTINGSFACT(NTRIPRTCMSource, gpggamessageHz)
DECLARE_SETTINGSFACT(NTRIPRTCMSource, mountpoint)
