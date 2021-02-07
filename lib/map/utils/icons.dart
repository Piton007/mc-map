
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:free_radar/model/event.dart';
import 'package:latlong/latlong.dart';
import 'package:flutter_svg_provider/flutter_svg_provider.dart';

Widget buildAssetIcon(String name, double size) {
  return ImageIcon(Svg('public/$name'), size: size);
}

class EventMarker extends Marker {
  final EventModel model;

  EventMarker._(
      {@required EventModel event,
      LatLng point,
      double width,
      double height,
      WidgetBuilder builder,
      AnchorPos anchorPos})
      : model = event,
        super(
            point: point,
            builder: builder,
            width: width,
            height: height,
            anchorPos: anchorPos);

  EventMarker.fromModel(
      {@required EventModel event,
      double width,
      double height,
      WidgetBuilder builder,
      AnchorPos anchorPos})
      : this._(
            point: event.point,
            event: event,
            width: width,
            height: height,
            builder: builder,
            anchorPos: anchorPos);
}

class MCMarker extends Marker {
  MCMarker(
      {LatLng point,
      double width,
      double height,
      WidgetBuilder builder,
      AnchorPos anchorPos})
      : super(
            point: point,
            builder: builder,
            width: width,
            height: height,
            anchorPos: anchorPos);
}
