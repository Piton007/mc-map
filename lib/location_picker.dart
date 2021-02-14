import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:free_radar/map/utils/icons.dart';
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

    return Scaffold(
      appBar: AppBar(
        title: Text("Ubicación del evento"),
      ),
      body: SafeArea(
        child: FlexMap(
          onTap: _pickEventLocation,
          mapController: mapController,
          markers: markers,
        ),
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: "event location picker",

        child: buildAssetIcon("user.svg", 30),
        backgroundColor: Colors.red[800],
        onPressed: ()=> backToCreateEventView(context),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );


  }

  void backToCreateEventView(context){
    Navigator.pop(context,this.markers.last.point);
  }

  void _pickEventLocation (LatLng point){

    this.setState(() {

      this.markers = List.from([buildEventMarker(point)]);

    });
  }
}
