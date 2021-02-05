
import 'package:cloud_firestore/cloud_firestore.dart';



class EventModel {
  final String creador;
  final int cupos;
  final String nombre;
  final GeoPoint ubicacion;

  EventModel({this.creador,this.cupos,this.nombre,this.ubicacion});

  factory EventModel.fromJson(Map<String,dynamic> json){
    return EventModel(
      creador:json['creador'] as String,
      cupos: json['cupos'] as int,
      nombre: json['nombre'] as String,
      ubicacion: json['ubicacion'] as GeoPoint
    );
  }


}