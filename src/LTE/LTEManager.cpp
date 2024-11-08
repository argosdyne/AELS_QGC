#include "LTEManager.h"
#include "QGCApplication.h"
#include "JsonHelper.h"
#include "CustomPlugin.h"
#include <QJsonObject>
#include <QJsonDocument>
#include <QTextCodec>
#include <QNetworkCookieJar>
#include <QNetworkCookie>
#include <QRegularExpression>
#include <QRegularExpressionMatch>

QGC_LOGGING_CATEGORY(LTEManagerLog, "LTEManagerLog")

#define LTE_LOGIN_URL QString("http://%1/admin/login/").arg(_settings->serverURL()->enumOrValueString())
#define LTE_LOGOUT_URL QString("http://%1/admin/logout/").arg(_settings->serverURL()->enumOrValueString())
#define LTE_JSON_DATA_URL QString("http://%1/console/?format=json").arg(_settings->serverURL()->enumOrValueString())

LTEManager::LTEManager(QGCApplication *app, QGCToolbox *toolbox)
    : QGCTool(app, toolbox)
    , _plugin(qobject_cast<CustomPlugin*>(toolbox->corePlugin()))
{
    _networkManager.setTransferTimeout(5000);
    connect(&_networkManager, &QNetworkAccessManager::finished, this, &LTEManager::_handleNetworkManagerFinished);
}

LTEManager::~LTEManager()
{
    _drones.deleteListAndContents();
}

void LTEManager::setToolbox(QGCToolbox *toolbox)
{
    QGCTool::setToolbox(toolbox);

    _settings = new LTESettings(this);

    QQmlEngine::setObjectOwnership(this, QQmlEngine::CppOwnership);
    qmlRegisterUncreatableType<LTEManager>("CustomQuickInterface", 1, 0, "LTEManager", "Reference only");

    if(_settings->autoLogin()->rawValue().toBool()) login();
}

bool LTEManager::droneConnected()
{
    for(int i = 0; i < _drones.count(); i++) {
        if(_drones.value<LTEItem*>(i)->frpcRunning()) {
            return true;
        }
    }
    return false;
}

LTEItem* LTEManager::connectedDrone()
{
    for(int i = 0; i < _drones.count(); i++) {
        if(_drones.value<LTEItem*>(i)->frpcRunning()) {
            return _drones.value<LTEItem*>(i);
        }
    }
    return nullptr;
}

void LTEManager::setLogined(const bool &logined)
{
    setLogining(false);
    _settings->autoLogin()->setRawValue(_logined);
    if(logined == _logined) return;
    _logined = logined;
    if(_logined) {
        qCInfo(LTEManagerLog) << "LTE Login";
    } else {
        qCInfo(LTEManagerLog) << "LTE Logout";
    }
    emit loginedChanged(_logined);
}

void LTEManager::setLogining(const bool &logining)
{
    if(logining == _logining) return;
    _logining = logining;
    emit loginingChanged(_logining);
}

void LTEManager::login()
{
    Fact* usernameFact = _settings->username();
    Fact* passwordFact = _settings->password();
    Fact* urlFact = _settings->serverURL();
    if(usernameFact->enumOrValueString().isEmpty() ||
       passwordFact->enumOrValueString().isEmpty() ||
       urlFact->enumOrValueString().isEmpty()) return;
    QNetworkRequest request(QUrl(LTE_LOGIN_URL));
    _networkManager.clearAccessCache();
    setLogined(false);
    setLogining(true);
    _networkManager.get(request);
}

void LTEManager::logout()
{
    QNetworkRequest request(QUrl(LTE_LOGOUT_URL));
    _networkManager.get(request);
    _drones.clearAndDeleteContents();
}

void LTEManager::refresh()
{
    QNetworkRequest request(QUrl(LTE_JSON_DATA_URL));
    _networkManager.get(request);
}

void LTEManager::start(LTEItem* item)
{
    for(int i = 0; i < _drones.count(); i++) {
        LTEItem* it = _drones.value<LTEItem*>(i);
        if(item == it) {
            if(!item->frpcRunning()) {
                item->start();
            }
        } else {
            it->stop();
        }
    }
}

void LTEManager::_handleNetworkManagerFinished(QNetworkReply *reply)
{
    if(reply->attribute(QNetworkRequest::HttpStatusCodeAttribute) == 401) {
        setLogined(false);
    }
    if(reply->error()) {
        setLogined(false);
        _plugin->showMessage(tr("LTE Server Error: %1").arg(reply->error()), SystemMessage::Error);
    } else if(reply->url().toString().compare(LTE_LOGIN_URL) == 0) {
        QNetworkCookieJar* jar = _networkManager.cookieJar();
        QList<QNetworkCookie> cookies = jar->cookiesForUrl(reply->url());
        QString csrftoken;
        QString sessionid;
        foreach(QNetworkCookie cookie, cookies) {
            if(QString(cookie.name()).compare("csrftoken") == 0) {
                csrftoken = QString(cookie.value());
            } else if(QString(cookie.name()).compare("sessionid") == 0) {
                sessionid = QString(cookie.value());
            }
        }
        if(!sessionid.isEmpty()) {
            setLogined(true);
        } else if(!csrftoken.isEmpty()) {
            QString data = QString("csrfmiddlewaretoken=%1&username=%2&password=%3").arg(csrftoken).arg(_settings->username()->enumOrValueString()).arg(_settings->password()->enumOrValueString());
            QNetworkRequest request(QUrl(LTE_LOGIN_URL));
            request.setHeader(QNetworkRequest::ContentTypeHeader, "application/x-www-form-urlencoded");
            _networkManager.post(request, data.toLatin1());
        }
    } else if(reply->url().toString().compare(LTE_LOGOUT_URL) == 0) {
        _networkManager.clearAccessCache();
        setLogined(false);
    } else if(reply->url().toString().compare(LTE_JSON_DATA_URL) == 0) {
        QByteArray result_data = reply->readAll();
        QJsonParseError jsonParseError;
        QJsonDocument doc = QJsonDocument::fromJson(result_data, &jsonParseError);
        if (jsonParseError.error != QJsonParseError::NoError) {
            _plugin->showMessage(tr("Json Parse Error: %1").arg(jsonParseError.errorString()), SystemMessage::Error);
            return;
        }
        if (!doc.isArray()) {
            qCWarning(LTEManagerLog) << "json document is not array";
            return;
        }
        QJsonArray jsonArray = doc.array();
        for (int i=0; i<jsonArray.count(); i++) {
            QJsonValueRef jsonValue = jsonArray[i];

            if (!jsonValue.isObject()) {
                qCWarning(LTEManagerLog) << QStringLiteral("JsonValue at index %1 not an object").arg(i);
                continue;
            }

            QJsonObject jsonObject = jsonValue.toObject();
            QString errorString;
            QStringList requiredKeys;
            requiredKeys << "state" << "name" << "aircraft" << "airport" << "groundcontrol" << "downloads";
            if (!JsonHelper::validateRequiredKeys(jsonObject, requiredKeys, errorString)) {
                continue;
            }

            LTEItem* item = getLTEItem(jsonObject.value("name").toString());
            item->update(jsonObject);
        }
    }
}

LTEItem* LTEManager::getLTEItem(QString name)
{
    for(int i = 0; i < _drones.count(); i++) {
        if(name.compare(_drones.value<LTEItem*>(i)->name()) == 0) {
            return _drones.value<LTEItem*>(i);
        }
    }
    LTEItem* item = new LTEItem(&_networkManager, _settings, this);
    connect(item, &LTEItem::frpcRunningChanged, this, &LTEManager::droneConnectedChanged);
    _drones.append(item);
    return item;
}

LTEItem::LTEItem(QNetworkAccessManager* manager, LTESettings* settings, QObject* parent)
    : QObject(parent)
    , _manager(manager)
    , _settings(settings)
{
    connect(this, &LTEItem::downloadComplete, this, &LTEItem::_runFrpc);
}

LTEItem::~LTEItem()
{
    if(_frpc) {
        _frpc->close();
        delete _frpc;
        _frpc = nullptr;
    }
}

void LTEItem::update(const QJsonObject& data)
{
    QJsonObject jsonObject = data;
    
    if (jsonObject.contains("name")) {
        QJsonValue name_value = jsonObject.take("name");
        if(name_value.isString()) {
            _name = name_value.toString();
        }
    }

    if (jsonObject.contains("state")) {
        QJsonValue state_value = jsonObject.take("state");
        if(state_value.isString()) {
            _running = (state_value.toString().compare("running") == 0);
        } else {
            _running = false;
        }
    }

    if (jsonObject.contains("aircraft")) {
        QJsonValue aircraft_value = jsonObject.take("aircraft");
        if(aircraft_value.isString()) {
            _hasAircraft = (aircraft_value.toString().compare("online") == 0);
        } else {
            _hasAircraft = false;
        }
    }

    if (jsonObject.contains("airport")) {
        QJsonValue airport_value = jsonObject.take("airport");
        if(airport_value.isString()) {
            _hasAirport = (airport_value.toString().compare("online") == 0);
        } else {
            _hasAirport = false;
        }
    }

    if (jsonObject.contains("groundcontrol")) {
        QJsonValue groundcontrol_value = jsonObject.take("groundcontrol");
        if(groundcontrol_value.isString()) {
            _hasGroundcontrol = (groundcontrol_value.toString().compare("online") == 0);
        } else {
            _hasGroundcontrol = false;
        }
    }

    _downloads.clear();
    if (jsonObject.contains("downloads")) {
        QJsonValue downloads_value = jsonObject.take("downloads");
        if (downloads_value.isArray()) {
            QJsonArray jsonArray = downloads_value.toArray();
            for (int i=0; i<jsonArray.count(); i++) {
                QJsonValueRef jsonValue = jsonArray[i];
                if (jsonValue.isObject()) {
                    QJsonObject jsonObject = jsonValue.toObject();
                    QString errorString;
                    QStringList requiredKeys;
                    requiredKeys << "name" << "url";
                    if (JsonHelper::validateRequiredKeys(jsonObject, requiredKeys, errorString)) {
                        _downloads[jsonObject.value("name").toString()] = jsonObject.value("url").toString();
                    }
                }
            }
        }
    }

    emit stateChanged();
}

void LTEItem::start(QString name)
{
    if(_downloads.contains(name)) {
        QUrl remoteUrl(QString("http://%1%2").arg(_settings->serverURL()->enumOrValueString()).arg(_downloads[name]));

        QNetworkRequest networkRequest(remoteUrl);

        QNetworkProxy tProxy;
        tProxy.setType(QNetworkProxy::DefaultProxy);
        _manager->setProxy(tProxy);
        
        QNetworkReply* networkReply = _manager->get(networkRequest);
        if (!networkReply) {
            qCWarning(LTEManagerLog) << "QNetworkAccessManager::get failed";
            return;
        }

        _busy = true;
        emit busyChanged();
        connect(networkReply, &QNetworkReply::finished, this, &LTEItem::_downloadFinished);
        connect(networkReply, &QNetworkReply::errorOccurred, this, &LTEItem::_downloadError);
    }
}

void LTEItem::stop()
{
    if(_frpc) {
        _frpc->close();
        delete _frpc;
        _frpc = nullptr;
    }
}

void LTEItem::_runFrpc(QString localFile)
{
    if(_frpc) {
        _frpc->close();
        delete _frpc;
        _frpc = nullptr;
    }

    _frpc = new QProcess(this);
#if defined (Q_OS_WIN)
    QString exeName = "frpc.exe";
#else
    QString exeName = "frpc";
#endif
#if defined (Q_OS_ANDROID)
    QString path = "/system/bin";
#else
    QString path = "";
#endif
    QString url = QDir(path).filePath(exeName);
    QStringList exeParam;
    exeParam.append("-c");
    exeParam.append(localFile);
    connect(_frpc, QOverload<int, QProcess::ExitStatus>::of(&QProcess::finished), this, &LTEItem::_frpcFinished);
    _frpc->start(url, exeParam);
    _frpcRunning = _frpc->waitForStarted();
    emit frpcRunningChanged();
    _busy = false;
    emit busyChanged();
}

void LTEItem::_frpcFinished(int exitCode, QProcess::ExitStatus exitStatus)
{
    _frpcRunning = false;
    emit frpcRunningChanged();
}

void LTEItem::_downloadFinished(void)
{
    QNetworkReply* reply = qobject_cast<QNetworkReply*>(QObject::sender());

    // When an error occurs or the user cancels the download, we still end up here. So bail out in
    // those cases.
    if (reply->error() != QNetworkReply::NoError) {
        reply->deleteLater();
        _busy = false;
        emit busyChanged();
        return;
    }

    // Split out filename from path
    QString remoteFileName = "groundcontrol.ini";
    QRegularExpression re("id=(?<target>\\w+)$");
    QRegularExpressionMatch match = re.match(reply->url().toString());
    if (match.hasMatch()) {
        remoteFileName = QString("%1.ini").arg(match.captured("target"));
    }

    // Determine location to download file to
    QString downloadFilename = QStandardPaths::writableLocation(QStandardPaths::TempLocation);
    if (downloadFilename.isEmpty()) {
        downloadFilename = QStandardPaths::writableLocation(QStandardPaths::DownloadLocation);
        if (downloadFilename.isEmpty()) {
            _busy = false;
            emit busyChanged();
            qCWarning(LTEManagerLog) << tr("Unabled to find writable download location. Tried downloads and temp directory.");
            return;
        }
    }
    downloadFilename += "/"  + remoteFileName;

    if (!downloadFilename.isEmpty()) {
        // Store downloaded file in download location
        QFile file(downloadFilename);
        if (!file.open(QIODevice::WriteOnly | QIODevice::Truncate)) {
            _busy = false;
            emit busyChanged();
            qCWarning(LTEManagerLog) << tr("Could not save downloaded file to %1. Error: %2").arg(downloadFilename).arg(file.errorString());
            return;
        }

        file.write(reply->readAll());
        file.close();

        if(file.size()) {
            emit downloadComplete(downloadFilename);
        } else {
            _busy = false;
            emit busyChanged();
        }
    } else {
        QString errorMsg = "Internal error";
        qCWarning(LTEManagerLog) << errorMsg;
    }

    reply->deleteLater();
}

void LTEItem::_downloadError(QNetworkReply::NetworkError code)
{
    _busy = false;
    emit busyChanged();
    QString errorMsg;
    
    if (code == QNetworkReply::OperationCanceledError) {
        errorMsg = tr("Download cancelled");

    } else if (code == QNetworkReply::ContentNotFoundError) {
        errorMsg = tr("Error: File Not Found");

    } else {
        errorMsg = tr("Error during download. Error: %1").arg(code);
    }

    qCWarning(LTEManagerLog) << errorMsg;
}
