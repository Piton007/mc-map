
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:free_radar/map/service/gps.dart';
import 'map/utils/icons.dart' show UserLocation, buildAssetIcon,CustomMarker;
import 'popupMarker.dart';
import 'package:latlong/latlong.dart';
import 'package:flutter_map_marker_popup/flutter_map_marker_popup.dart';



class MapPage extends StatefulWidget {
  MapPage(GlobalKey<MapPageState> key) : super(key: key);
  

  @override
  MapPageState createState() => MapPageState();
}

class MapPageState extends State<MapPage> {
  static final List<LatLng> _points = [
    LatLng(-13.04318, -77.02824),
    LatLng(-10.04318, -77.02824)
  ];


  final MapController mapController  = MapController();

  UserLocation _currentLocation;

  static const _markerSize = 80.0;
  List<CustomMarker> _markers;


  // Used to trigger showing/hiding of popups.
  final PopupController _popupLayerController = PopupController();

  MapPageState();


  @override
  void initState() {
    super.initState();
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
  Widget build(BuildContext context) {
    return FlutterMap(

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
    );
  }

  void focusCurrentPos() {
    this.mapController.move(this._markers.first.point,this.mapController.zoom );
  }

  void showPopupForFirstMarker() {
    _popupLayerController.togglePopup(_markers.first);
  }
}