import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_compass/flutter_compass.dart';
import 'package:flutter_map/plugin_api.dart';
import 'utils.dart';
import 'package:location/location.dart';
import 'package:latlong/latlong.dart';

import 'gps_marker.dart';
import 'gps_options.dart';

GPSMarkerBuilder _defaultMarkerBuilder =
    (BuildContext context, LatLngData ld, ValueNotifier<double> heading) {
  final double diameter = ld != null && ld.highAccurency() ? 60.0 : 120.0;
  return Marker(
    point: ld.location,
    builder: (_) => GPSMarker(ld: ld, heading: heading),
    height: diameter,
    width: diameter,
  );
};

class GPSLayer extends StatefulWidget {
  const GPSLayer({Key key, @required this.options, this.map, this.stream})
      : assert(options != null),
        super(key: key);

  final GPSOptions options;
  final MapState map;

  final Stream<void> stream;

  @override
  _GPSLayerState createState() => _GPSLayerState();
}

class _GPSLayerState extends State<GPSLayer>
    with WidgetsBindingObserver {
  final Location _location = Location();
  final ValueNotifier<GPSServiceStatus> _serviceStatus =
  ValueNotifier<GPSServiceStatus>(null);
  final ValueNotifier<LatLngData> _lastLocation =
  ValueNotifier<LatLngData>(null);
  final ValueNotifier<double> _heading = ValueNotifier<double>(null);

  StreamSubscription<LocationData> _onLocationChangedSub;
  StreamSubscription<double> _compassEventsSub;
  bool _locationRequested = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _location.changeSettings(interval: widget.options.updateIntervalMs);
    _locationRequested = true;
    _initOnLocationUpdateSubscription()
        .then((GPSServiceStatus status) => _serviceStatus.value = status);
    _lastLocation.addListener(() {
      final LatLngData loc = _lastLocation.value;
      widget.options.onLocationUpdate?.call(loc);
     if (widget.options.markers.isNotEmpty) {
        widget.options.markers.removeLast();
      }
      if (loc == null || loc.location == null) {
        return;
      }
      widget.options.markers.add(widget.options.markerBuilder != null
          ? widget.options.markerBuilder(context, loc, _heading)
          : _defaultMarkerBuilder(context, loc, _heading));
      if (_locationRequested) {
        _locationRequested = false;
        widget.options.onLocationRequested?.call(loc);
      }
    });
  }

  @override
  void dispose() {
    _compassEventsSub?.cancel();
    _onLocationChangedSub?.cancel();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    switch (state) {
      case AppLifecycleState.paused:
        _compassEventsSub?.cancel();
        _onLocationChangedSub?.cancel();
        if (_serviceStatus?.value == GPSServiceStatus.subscribed) {
          _serviceStatus.value = GPSServiceStatus.paused;
        } else {
          _serviceStatus.value = null;
        }
        break;
      case AppLifecycleState.resumed:
        if (_serviceStatus?.value == GPSServiceStatus.paused) {
          _serviceStatus.value = null;
          _initOnLocationUpdateSubscription().then(
                  (GPSServiceStatus value) => _serviceStatus.value = value);
        }
        break;
      case AppLifecycleState.inactive:
      case AppLifecycleState.detached:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget.options.buttonBuilder(context, _serviceStatus, () async {
      if (_serviceStatus?.value == GPSServiceStatus.disabled) {
        if (!await _location.requestService()) {
          return;
        }
        _serviceStatus.value = null;
      }
      if (_serviceStatus?.value != GPSServiceStatus.subscribed ||
          _lastLocation?.value == null ||
          !await _location.serviceEnabled()) {
        _initOnLocationUpdateSubscription().then(
                (GPSServiceStatus value) => _serviceStatus.value = value);
        _locationRequested = true;
      } else {
        widget.options.onLocationRequested?.call(_lastLocation.value);
      }
    });
  }

  Future<GPSServiceStatus> _initOnLocationUpdateSubscription() async {
    if (!await _location.serviceEnabled()) {
      _lastLocation.value = null;
      return GPSServiceStatus.disabled;
    }
    if (await _location.hasPermission() == PermissionStatus.denied) {
      if (await _location.requestPermission() != PermissionStatus.granted) {
        _lastLocation.value = null;
        return GPSServiceStatus.permissionDenied;
      }
    }
    await _onLocationChangedSub?.cancel();
    _onLocationChangedSub =
        _location.onLocationChanged.listen((LocationData ld) {
          _lastLocation.value = _locationDataToLatLng(ld);
        }, onError: (Object error) {
          _lastLocation.value = null;
          _serviceStatus.value = GPSServiceStatus.unsubscribed;
        }, onDone: () {
          _lastLocation.value = null;
          _serviceStatus.value = GPSServiceStatus.unsubscribed;
        });
    await _compassEventsSub?.cancel();
    _compassEventsSub = FlutterCompass.events.listen((double value) {
      _heading.value = value;
    });
    return GPSServiceStatus.subscribed;
  }
}

LatLngData _locationDataToLatLng(LocationData ld) {
  if (ld.latitude == null || ld.longitude == null) {
    return null;
  }
  return LatLngData(LatLng(ld.latitude, ld.longitude), ld.accuracy);
}