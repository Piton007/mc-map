import 'dart:async';

import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:free_radar/gps/gps.dart';
import 'package:free_radar/map/service/gps.dart';
import 'package:free_radar/model/event.dart';
import 'package:free_radar/rapper_map.dart';
import 'package:free_radar/rapper_map_plugin.dart';
import 'package:geolocator/geolocator.dart';
import 'map/utils/icons.dart' ;
import 'package:latlong/latlong.dart';
import 'package:flutter_map_marker_popup/flutter_map_marker_popup.dart';
import 'rap_events.dart';

class MapPage extends StatefulWidget {
  MapPage(GlobalKey<MapPageState> key) : super(key: key);

  @override
  MapPageState createState() => MapPageState(new GPSService());
}

class MapPageState extends State<MapPage> {


  final GPSService service;
  final events = BlocProvider.getBloc<EventBloc>();
  final MapController mapController = MapController();
  static const _markerSize = 80.0;
  List<Marker> _markers;

  // Used to trigger showing/hiding of popups.
  final PopupController _popupLayerController = PopupController();

  MapPageState(GPSService service) : service = service;
  StreamSubscription<Position> userLocationSub;
  StreamSubscription<QuerySnapshot> markersSub;



  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    markersSub.cancel();
    userLocationSub.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: events.stream,
        builder: (context, AsyncSnapshot<QuerySnapshot> stream) {
          if (stream.hasData) {
             List<Marker> markers = stream.data?.docs?.map((e) =>
                EventMarker.fromModel(
                    event: EventModel.fromDocument(e),
                    builder: (_) =>
                        buildAssetIcon("marker_logo.svg", _markerSize),
                    height: _markerSize,
                    width: _markerSize
                )

            )?.toList()

                ??
                [];
            return FlexMap(
              markers: markers,
              onTap: (LatLng pos) => _popupLayerController.hidePopup(),
              mapController: mapController,
              plugins: [GPSPlugin(),PopupMarkerPlugin()],
              pluginOptions: [gpsPluginOptions(markers, () =>  focusCurrentPos(markers)),popupPluginOptions(markers:markers,popupController: _popupLayerController)],
            );
          } else {
            return Icon(Icons.access_alarm);
          }
        });

  }

  void focusCurrentPos(List<Marker> markers) {

    mapController?.move(markers.last.point, mapController?.zoom);
  }

  void showPopupForFirstMarker() {
    _popupLayerController.togglePopup(_markers.first);
  }
}
