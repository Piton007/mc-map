import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_marker_popup/flutter_map_marker_popup.dart';
import 'package:free_radar/popupMarker.dart';
import 'gps/gps_options.dart';
import 'map/utils/icons.dart';


LayerOptions gpsPluginOptions(List<Marker> markers, void Function() onTap){
  return GPSOptions(markers: markers, buttonBuilder: _defaultGPSButton(onTap));
}

LayerOptions popupPluginOptions({List<Marker> markers, dynamic popupController }){
  return PopupMarkerLayerOptions(
      markers: markers,
      popupSnap: PopupSnap.top,
      popupController: popupController,
      popupBuilder: (BuildContext _,Marker marker) =>
      (marker is MCMarker) ? new Container() : EventPopup(marker,popupController)
  );
}


GPSButtonBuilder _defaultGPSButton(void Function() onTap){
  return (BuildContext context,
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
            onPressed: onTap),
      ),
    );
  };
}