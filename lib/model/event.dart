import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:latlong/latlong.dart';

class EventModel {
  final String creador;
  final int cupos;
  final String nombre;
  final GeoPoint ubicacion;

  EventModel({this.creador, this.cupos, this.nombre, this.ubicacion});

  factory EventModel.fromJson(Map<String, dynamic> json) {
    return EventModel(
        creador: json['creador'] as String,
        cupos: json['cupos'] as int,
        nombre: json['nombre'] as String,
        ubicacion: json['ubicacion'] as GeoPoint);
  }
   Map<String,dynamic> toJSON(){
    return {
      "creador":this.creador,
      "cupos":this.cupos,
      "nombre":this.nombre,
      "ubicacion":this.ubicacion
    };
  }

  EventModel.fromDocument(QueryDocumentSnapshot document)
      : this.creador = document['creador'],
        this.cupos = 2,
        this.nombre = document['nombre'],
        this.ubicacion = document['ubicacion'] as GeoPoint;

  get point {
    return LatLng(this.ubicacion.latitude, this.ubicacion.longitude);
  }

  bool isAvailable() {
    return cupos > 0;
  }
}
