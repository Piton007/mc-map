import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong/latlong.dart';

import 'map/utils/icons.dart';

class FlexMap extends StatelessWidget {
  final MapController mapController;
  final List<MapPlugin> plugins ;
  final void Function(LatLng location) onTap;
  final List<LayerOptions> pluginOptions ;
  final List<Marker> markers;
  final LIMA_COORDINATES = LatLng(-12.04318, -77.02824);


  FlexMap(
      {this.mapController,
      this.markers,
      this.plugins = const [],
        this.pluginOptions  =  const [],
        this.onTap
      }
      );



  @override
  Widget build(BuildContext context) {
    return FlutterMap(
      mapController: mapController,
        options: new MapOptions(
      maxZoom: 18.0,
      center: LIMA_COORDINATES,
      minZoom: 5.0,
      zoom: 13.0,
            onTap: this.onTap,
          plugins: this.plugins
    ),
      layers: [
        TileLayerOptions(
            urlTemplate:
            'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
            subdomains: ['a', 'b', 'c']),
        ...((this.pluginOptions.isEmpty) ? _defaultLayerOptions() : this.pluginOptions)

      ],

    );
  }
  List<LayerOptions> _defaultLayerOptions(){
    return List.from([MarkerLayerOptions(markers:markers)]);
  }
}

Marker buildEventMarker(LatLng point) => Marker(point: point,builder: (_) =>
    buildAssetIcon("marker_logo.svg", 60), height: 60,width: 60);
