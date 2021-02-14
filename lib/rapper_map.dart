import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong/latlong.dart';

class FlexMap extends StatelessWidget {
  final MapController mapController;
  final List<MapPlugin> plugins ;
  final void Function(LatLng location) onTap;
  final List<LayerOptions> pluginOptions ;
  final List<Marker> markers;


  FlexMap(
      {this.mapController,
      this.markers,
      this.plugins = const [],
        this.pluginOptions  = const [],
        this.onTap
      }
      );



  @override
  Widget build(BuildContext context) {
    return new FlutterMap(
        options: new MapOptions(
      maxZoom: 18.0,
      minZoom: 10.0,
            onTap: this.onTap,
          plugins: this.plugins
    ),
      layers: [
        TileLayerOptions(
            urlTemplate:
            'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
            subdomains: ['a', 'b', 'c']),
        ...this.pluginOptions
      ],

    );
  }
}
