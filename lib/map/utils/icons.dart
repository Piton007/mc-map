import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong/latlong.dart';
import 'package:flutter_svg_provider/flutter_svg_provider.dart';

Widget buildAssetIcon(String name,double size){
  return ImageIcon(Svg('public/$name'),size:size);
}

class UserLocation {
  LatLng location;
  double _size;
  final String _imageURI = "user.svg";

  UserLocation(LatLng location,double size): location = location, _size = size;



  Marker drawMarker(){
    return Marker(
      point: location,
      width: _size,
      height: _size,
      builder: (_) => buildAssetIcon(_imageURI, _size),
      anchorPos: AnchorPos.align(AnchorAlign.top)
    );
  }
}