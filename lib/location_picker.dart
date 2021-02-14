import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:free_radar/rapper_map.dart';
import 'package:latlong/latlong.dart';



class LocationPicker extends StatefulWidget {
  @override
  _LocationPickerState createState() => _LocationPickerState();
}

class _LocationPickerState extends State<LocationPicker> {
  
  List<Marker> markers = [buildEventMarker(LatLng(-12.04318, -77.02824))];
  int counter = 0;
  final MapController mapController = MapController();
  
  @override
  Widget build(BuildContext context) {

    return FlexMap(
        onTap: _pickEventLocation,
      mapController: mapController,
      markers: markers,
    );
  }


  void _pickEventLocation (LatLng point){

    this.setState(() {

      this.markers = List.from([buildEventMarker(point)]);

    });
  }
}
