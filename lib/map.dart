import 'dart:async';

import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:free_radar/map/service/gps.dart';
import 'package:geolocator/geolocator.dart';
import 'map/utils/icons.dart' show UserLocation, buildAssetIcon, CustomMarker;
import 'popupMarker.dart';
import 'package:latlong/latlong.dart';
import 'package:flutter_map_marker_popup/flutter_map_marker_popup.dart';
import 'rap_events.dart';

class MapPage extends StatefulWidget {
  MapPage(GlobalKey<MapPageState> key) : super(key: key);

  @override
  MapPageState createState() => MapPageState(new GPSService());
}

class MapPageState extends State<MapPage> {
  static final List<LatLng> _points = [
    LatLng(-13.04318, -77.02824),
    LatLng(-10.04318, -77.02824)
  ];

  final GPSService service;
  final events = BlocProvider.getBloc<EventBloc>();
  final MapController mapController = MapController();

  UserLocation _currentLocation;

  static const _markerSize = 80.0;
  List<CustomMarker> _markers;

  // Used to trigger showing/hiding of popups.
  final PopupController _popupLayerController = PopupController();

  MapPageState(GPSService service) : service = service;
  StreamSubscription<Position> userLocationSub;

  @override
  void initState() {
    super.initState();
    userLocationSub = service.getCurrentLocation().asStream().listen((value) {
      setState(() {
        _markers.removeWhere(
            (CustomMarker element) => element.type == CustomMarker.USER_TYPE);
        _currentLocation =
            UserLocation(LatLng(value.latitude, value.longitude), 60.0);
        var _newMarkers =
            List<CustomMarker>.from([_currentLocation.drawMarker()]);
        _newMarkers.addAll(_markers);
        _markers = _newMarkers;
        this.focusCurrentPos();
      });
    });
    _markers = _points
        .map(
          (LatLng point) => CustomMarker(
            point: point,
            width: _markerSize,
            height: _markerSize,
            builder: (_) => buildAssetIcon("marker_logo.svg", _markerSize),
            anchorPos: AnchorPos.align(AnchorAlign.top),
          ),
        )
        .toList();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    userLocationSub.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: events.stream,
        builder: (context, AsyncSnapshot<QuerySnapshot> stream) {
          if (stream.hasData) {

            return FlutterMap(
              mapController: mapController,
              options: new MapOptions(
                  maxZoom: 18.0,
                  plugins: [PopupMarkerPlugin()],
                  onTap: (LatLng pos) {
                    _popupLayerController.hidePopup();
                  }),
              layers: [
                TileLayerOptions(
                    urlTemplate:
                        'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                    subdomains: ['a', 'b', 'c']),
                PopupMarkerLayerOptions(
                  markers: stream.data?.docs?.map((e) => Marker(
                            point: LatLng((e['ubicacion'] as GeoPoint).latitude , (e['ubicacion'] as GeoPoint).longitude),
                            builder: (_) =>
                                buildAssetIcon("marker_logo.svg", _markerSize),
                            height: _markerSize,
                            width: _markerSize
                  )
                  )?.toList()

                      ??
                      [],
                  popupSnap: PopupSnap.top,
                  popupController: _popupLayerController,
                  popupBuilder: (BuildContext _, Marker marker) =>
                      ExamplePopup(marker),
                ),
              ],
            );
          } else {
            return Icon(Icons.access_alarm);
          }
        });
    /*return FlutterMap(

      mapController: this.mapController,
      options: new MapOptions(

        maxZoom: 18.0,
        zoom: 5.0,
        center: _points.first,
        plugins: [PopupMarkerPlugin()],
        onTap: (LatLng pos) {
          print(pos);
          _popupLayerController.hidePopup();
        }
            , // Hide popup when the map is tapped.
      ),
      layers: [
        TileLayerOptions(
            urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
            subdomains: ['a', 'b', 'c']
        ),
        PopupMarkerLayerOptions(
          markers: _markers,
          popupSnap: PopupSnap.top,
          popupController: _popupLayerController,
          popupBuilder: (BuildContext _, Marker marker) => ExamplePopup(marker),
        ),
      ],
    );*/
  }

  void focusCurrentPos() {
    this.mapController.move(this._markers.first.point, this.mapController.zoom);
  }

  void showPopupForFirstMarker() {
    _popupLayerController.togglePopup(_markers.first);
  }
}
