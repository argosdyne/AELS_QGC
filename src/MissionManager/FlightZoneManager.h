#ifndef FLIGHTZONEMANAGER_H
#define FLIGHTZONEMANAGER_H

#include <QObject>
#include "GeoFenceManager.h"
#include "Vehicle.h"
#include <QSet>
#include <QNetworkAccessManager>
#include <QNetworkReply>
#include <QJsonDocument>
#include "SettingsManager.h"
#include "QGroundControlQmlGlobal.h"



class GeoFenceManager;

class FlightZoneManager : public QObject
{
    Q_OBJECT

public:
    FlightZoneManager();

    void testPolyhedronDistance();

    Q_PROPERTY(QmlObjectListModel*  polygons                READ polygons                                           CONSTANT)
    Q_PROPERTY(QmlObjectListModel*  circles                 READ circles                                            CONSTANT)


    Q_INVOKABLE void _init();
    Q_INVOKABLE void updatePolygonVisibility();

    //Check zoom value
    Q_INVOKABLE void checkCurrentZoomValue();

    QString getFilePath();
    void processJsonFile(const QString& filePath);
    Q_INVOKABLE void deletePolygon(int index);

    QmlObjectListModel* polygons                (void) { return &_polygons; }
    QmlObjectListModel* circles                 (void) { return &_circles; }

    void removeAll();
    // Test

    void fetchGeoJsonData();
    void processJsonFile(QJsonDocument jsonDoc);
    void fetchGeoJsonDataForRegion(double n, double e, double s, double w);
    void fetchGeoJsonForCzechRepublic();
    void test();
    void getOnlineGeoJsonData();
    void fetchGeoJsonDataForRegion();
    void calculateCornerCoordinates(double centerLat, double centerLon, double zoomLevel, double width, double height);
    void processPolygons(const QmlObjectListModel& polygons);

signals:
    void textChanged();


private slots:
    //Test
    void onReplyFinished(QNetworkReply *reply);


public slots:


private:
    Vehicle*            _managerVehicle =               nullptr;
    GeoFenceManager*    _geoFenceManager =              nullptr;
    bool                _dirty =                        false;
    QmlObjectListModel  _polygons;
    QmlObjectListModel  _circles;

    QSet<int> _removedPolygonIndices;
    QSet<int> _addedPolygonIndices;



    QTimer _timer;

    QTimer _zoomTimer;

    //Test
    QNetworkAccessManager *manager;
    SettingsManager*    _settingsManager = nullptr;
    QGCToolbox*         _toolbox = nullptr;

    QGroundControlQmlGlobal* qGroundControlQmlGlobal;

    QMetaObject::Connection connection;
    //TEst
    double zoomLevel;
};

class FlightValidTime {
public:
    qint64 polygonid;
    QDateTime validFrom;
    QDateTime validTo;
    bool isCreated = false;

    FlightValidTime(qint64 _polygonid, QDateTime _validFrom, QDateTime _validTo, bool _isCreated) :polygonid(_polygonid), validFrom(_validFrom), validTo(_validTo), isCreated(_isCreated) {}


};

class GeoJsonNameList {
public:
    QString name;

    GeoJsonNameList(QString _name) : name(_name) {}
    bool operator==(const GeoJsonNameList& other) const {
        return this->name == other.name;
    }
};

#endif // FLIGHTZONEMANAGER_H
