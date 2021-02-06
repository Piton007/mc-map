import 'package:flutter/widgets.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map/plugin_api.dart';
import 'utils.dart';

enum GPSServiceStatus {
  disabled,
  permissionDenied,
  subscribed,
  paused,
  unsubscribed,
}

typedef GPSButtonBuilder = Widget Function(BuildContext context,
    ValueNotifier<GPSServiceStatus>, Function onPressed);

typedef GPSMarkerBuilder = Marker Function(
    BuildContext context, LatLngData ld, ValueNotifier<double> heading);

class GPSOptions extends LayerOptions {
  GPSOptions(
      {@required this.markers,
        this.onLocationUpdate,
        this.onLocationRequested,
        @required this.buttonBuilder,
        this.markerBuilder,
        this.updateIntervalMs = 1000})
      : assert(markers != null, buttonBuilder != null),
        super();

  final void Function(LatLngData) onLocationUpdate;
  final void Function(LatLngData) onLocationRequested;
  final GPSButtonBuilder buttonBuilder;
  final GPSMarkerBuilder markerBuilder;
  final int updateIntervalMs;
  List<Marker> markers;
}