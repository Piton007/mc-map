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



  CustomMarker drawMarker(){
    return CustomMarker.makeUser(
      point: location,
      width: this._size,
      height: this._size,
      builder: (_) => buildAssetIcon(_imageURI, _size),
      anchorPos: AnchorPos.align(AnchorAlign.top)
    );
  }
}


class CustomMarker extends Marker {

  static const String USER_TYPE  = "user";
  static const String LOCATION_TYPE = "location";


  String _type;
  CustomMarker({
    String type= CustomMarker.LOCATION_TYPE,
    LatLng point,
    WidgetBuilder builder,
    double width,
    double height,
    AnchorPos anchorPos,
  }):super(point: point,builder: builder,width: width,height: height)
  {
    this._type = type;
  }


  CustomMarker.makeUser({
    LatLng point,
    WidgetBuilder builder,
    double width,
    double height,
    AnchorPos anchorPos,
  }):super(point: point,builder: builder,width: width,height: height){
    this._type  = CustomMarker.USER_TYPE;
  }

  get type {
    return this._type;
  }


}

