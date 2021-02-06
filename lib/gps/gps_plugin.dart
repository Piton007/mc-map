import 'package:flutter/widgets.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map/plugin_api.dart';


import 'gps_layer.dart';
import 'gps_options.dart';

class GPSPlugin extends MapPlugin {
  @override
  Widget createLayer(
      LayerOptions options, MapState mapState, Stream<void> stream) {
    if (options is GPSOptions) {
      return GPSLayer(options: options, map: mapState, stream: stream);
    }
    throw ArgumentError('options is not of type LocationOptions');
  }


  @override
  bool supportsLayer(LayerOptions options) {
    return options is GPSOptions;
  }
}