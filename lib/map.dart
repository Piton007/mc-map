import 'dart:async';

import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:free_radar/gps/gps.dart';
import 'package:free_radar/map/service/gps.dart';
import 'package:free_radar/model/event.dart';
import 'package:geolocator/geolocator.dart';
import 'map/utils/icons.dart' ;
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
            return FlutterMap(
              mapController: mapController,
              options: new MapOptions(
                  maxZoom: 18.0,
                  center: markers.last.point,
                  plugins: [GPSPlugin(),PopupMarkerPlugin()],
                  onTap: (LatLng pos) {
                    _popupLayerController.hidePopup();
                  }),
              layers: [
                TileLayerOptions(
                    urlTemplate:
                        'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                    subdomains: ['a', 'b', 'c']),

                GPSOptions(markers: markers, buttonBuilder: (BuildContext context,
                    ValueNotifier<GPSServiceStatus> status,
                    Function onPressed) {
                  return Align(
                    alignment: Alignment.bottomRight,
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 16.0, right: 16.0),
                      child: FloatingActionButton(
                          child: ValueListenableBuilder<GPSServiceStatus>(
                              valueListenable: status,
                              builder: (BuildContext context,
                                  GPSServiceStatus value, Widget child) {
                                switch (value) {
                                  case GPSServiceStatus.disabled:
                                  case GPSServiceStatus.permissionDenied:
                                  case GPSServiceStatus.unsubscribed:
                                    return const Icon(
                                      Icons.location_disabled,
                                      color: Colors.white,
                                    );
                                    break;
                                  default:
                                    return const Icon(
                                      Icons.location_searching,
                                      color: Colors.white,
                                    );
                                    break;
                                }
                              }),
                          onPressed: () => focusCurrentPos(markers)),
                    ),
                  );
                }),
                PopupMarkerLayerOptions(
                  markers: markers,
                  popupSnap: PopupSnap.top,
                  popupController: _popupLayerController,
                  popupBuilder: (BuildContext _,Marker marker) =>
           (marker is MCMarker) ? new Container() : EventPopup(marker)

                )
              ],
            );
          } else {
            return Icon(Icons.access_alarm);
          }
        });

  }

  void focusCurrentPos(List<Marker> markers) {
    this.mapController.move(markers.last.point, this.mapController.zoom);
  }

  void showPopupForFirstMarker() {
    _popupLayerController.togglePopup(_markers.first);
  }
}
