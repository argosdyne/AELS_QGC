/****************************************************************************
 *
 * (c) 2009-2020 QGROUNDCONTROL PROJECT <http://www.qgroundcontrol.org>
 *
 * QGroundControl is licensed according to the terms in the file
 * COPYING.md in the root of the source code directory.
 *
 ****************************************************************************/

#pragma once

#include "QGCMapPolygon.h"
#include <QColor>

/// The QGCFencePolygon class provides a polygon used by GeoFence support.
class QGCFencePolygon : public QGCMapPolygon
{
    Q_OBJECT

public:
    QGCFencePolygon(bool inclusion, QObject* parent = nullptr);
    QGCFencePolygon(const QGCFencePolygon& other, QObject* parent = nullptr);

    const QGCFencePolygon& operator=(const QGCFencePolygon& other);

    Q_PROPERTY(bool inclusion READ inclusion WRITE setInclusion NOTIFY inclusionChanged)

    Q_PROPERTY(QColor colorInclusion READ colorInclusion WRITE setcolorInclusion NOTIFY colorInclusionChanged)

    /// Saves the QGCFencePolygon to the json object.
    ///     @param json Json object to save to
    void saveToJson(QJsonObject& json);

    /// Load a QGCFencePolygon from json
    ///     @param json Json object to load from
    ///     @param required true: no polygon in object will generate error
    ///     @param errorString Error string if return is false
    /// @return true: success, false: failure (errorString set)
    bool loadFromJson(const QJsonObject& json, bool required, QString& errorString);

    // Property methods

    bool inclusion      (void) const { return _inclusion; }
    void setInclusion   (bool inclusion);
    void setcolorInclusion(QColor colorInclusion);
    QColor colorInclusion (void) const {return _colorInclusion;}

signals:
    void inclusionChanged   (bool inclusion);
    void colorInclusionChanged ();

private slots:
    void _setDirty(void);

private:
    void _init(void);

    bool _inclusion;

    QColor _colorInclusion;

    static const int _jsonCurrentVersion = 1;

    static const char* _jsonInclusionKey;
};
