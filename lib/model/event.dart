import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:latlong/latlong.dart';

class EventModel {
  DocumentReference reference;
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

  Future<bool> buyTicket(Transaction transaction) async {

      var snapshot = await transaction.get(this.reference);
      if (snapshot.exists){
        var tickets = int.tryParse(snapshot.data()['cupos'].toString());
        if (tickets > 0){
            tickets = tickets - 1;
            transaction.update(this.reference, {"cupos": tickets});
            return true;
        }
      }
      return false;
  }

  EventModel.fromDocument(QueryDocumentSnapshot document)
      : this.creador = document['creador'].toString(),
        this.cupos = int.tryParse(document['cupos'].toString()) ,
        this.nombre = document['nombre'].toString(),
        this.ubicacion = document['ubicacion'] as GeoPoint,
        this.reference = document.reference;

  get point {
    return LatLng(this.ubicacion.latitude, this.ubicacion.longitude);
  }

  bool isAvailable() {
    return cupos > 0;
  }
}
