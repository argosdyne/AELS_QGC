#ifndef FLIGHTZONEMANAGER_H
#define FLIGHTZONEMANAGER_H
#include <QObject>
#include "GeoFenceManager.h"
#include "QGCFencePolygon.h"
#include "QGCFenceCircle.h"
#include "Vehicle.h"
#include "MultiVehicleManager.h"
#include "QGCLoggingCategory.h"
#include <QSet>
class GeoFenceManager;
class FlightZoneManager : public QObject
{
    Q_OBJECT
public:
    FlightZoneManager();

    void testPolyhedronDistance();
    void testinout();

    Q_PROPERTY(QmlObjectListModel*  polygons                READ polygons                                           CONSTANT)
    Q_PROPERTY(QmlObjectListModel*  circles                 READ circles                                            CONSTANT)
    Q_INVOKABLE void _init();
    Q_INVOKABLE void updatePolygonVisibility();
    QString getFilePath();
    void processJsonFile(const QString& filePath);
    Q_INVOKABLE void deletePolygon(int index);
    QmlObjectListModel* polygons                (void) { return &_polygons; }
    QmlObjectListModel* circles                 (void) { return &_circles; }
    void removeAll();
signals:
private slots:
               // void _polygonDirtyChanged       (bool dirty);
               // void _setDirty                  (void);
               //void updatePolygonVisibility    (void);
private:
    Vehicle*            _managerVehicle =               nullptr;
    GeoFenceManager*    _geoFenceManager =              nullptr;
    bool                _dirty =                        false;
    QmlObjectListModel  _polygons;
    QmlObjectListModel  _circles;
    QSet<int> _removedPolygonIndices;
    QSet<int> _addedPolygonIndices;
    QTimer _timer;
};
class FlightValidTime {
public:
    qint64 polygonid;
    QDateTime validFrom;
    QDateTime validTo;
    bool isCreated = false;
    FlightValidTime(qint64 _polygonid, QDateTime _validFrom, QDateTime _validTo, bool _isCreated) :polygonid(_polygonid), validFrom(_validFrom), validTo(_validTo), isCreated(_isCreated) {}
};
#endif // FLIGHTZONEMANAGER_H
