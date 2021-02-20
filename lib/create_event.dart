import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:free_radar/location_picker.dart';
import "model/event.dart";

import 'package:latlong/latlong.dart';
import 'package:geocoding/geocoding.dart';

const CUPOS_UPPER_LIMIT = 100;
const CUPOS_LOWER_LIMIT = 5;

bool isInCuposRange(int cant) =>
    cant >= CUPOS_LOWER_LIMIT && cant <= CUPOS_UPPER_LIMIT;

class CreateEventForm extends StatefulWidget {
  @override
  _CreateEventFormState createState() => _CreateEventFormState();
}

class _CreateEventFormState extends State<CreateEventForm> {
  final _formKey = GlobalKey<FormState>();
  final creatorController = TextEditingController();
  final nameController = TextEditingController();
  final ticketsController = TextEditingController();
  final addressController = TextEditingController();

  LatLng eventLocation;


  @override
  Widget build(BuildContext context) {
    return Form(
        key: _formKey,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              TextFormField(
                controller: creatorController,
                key: UniqueKey(),

                decoration: const InputDecoration(
                    icon: Icon(Icons.account_balance),
                    hintText: '¿Cómo te llamas?',
                    labelText: 'Creador'),
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Ingresa tu nombre';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: nameController,
                key: UniqueKey(),

                decoration: const InputDecoration(
                    icon: Icon(Icons.assignment),
                    hintText: '¿Cómo se llama tu evento?',
                    labelText: 'Nombre'),
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Ingresa el nombre de tu evento';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: ticketsController,
                key: UniqueKey(),

                decoration: const InputDecoration(
                    icon: Icon(Icons.accessibility),
                    hintText: '¿Cuántos cupos tendrá?',
                    labelText: 'Cupos'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  var quantity = int.tryParse(value);
                  var result;
                  if (quantity == null) {
                    result = 'Ingresa un numero válido';
                  } else if (!isInCuposRange(quantity)) {
                    result = 'El rango de cupos es de 5 a 100';
                  }

                  return result;
                },
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                      child: TextFormField(
                        key: UniqueKey(),
                        decoration: const InputDecoration(
                            icon: Icon(Icons.location_on_rounded),
                            labelText: 'Ubicación'),
                        controller: addressController,
                        validator: (value) {
                          var result;
                          if (value.isEmpty) {
                            result = 'Selecciona la ubicación de tu evento';
                          }

                          return result;
                        },
                      ),
                      flex: 4),
                  Expanded(
                      child: IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: () => navigateToLocationPicker(context),
                      ),
                      flex: 1)
                ],
              ),
              Container(
                margin: EdgeInsets.symmetric(vertical: 10, horizontal: 5),
                child: Center(
                  child: ElevatedButton(
                    onPressed: () async {
                      // Validate returns true if the form is valid, or false
                      // otherwise.

                      if (_formKey.currentState.validate()) {
                        var event = EventModel(
                            creador: creatorController.text,
                            cupos: int.tryParse(ticketsController.text),
                            nombre: nameController.text,
                            ubicacion: GeoPoint(eventLocation.latitude,
                                eventLocation.longitude));
                        // If the form is valid, display a Snackbar.
                        FirebaseFirestore.instance
                            .collection('rap_events')
                            .add(event.toJSON())
                            .then((_) {
                          displayNotification(context);
                          resetForm();
                        });

                      }
                    },
                    child: Text('Submit'),
                  ),
                ),
              ),
            ],
          ),
        ));
  }

  void displayNotification(BuildContext context) {
    var snackBar =
        SnackBar(content: Text('Tu evento se ha creado exitosamente!'));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  Future<void> navigateToLocationPicker(BuildContext context) async {
    LatLng result = await Navigator.push(
        context, MaterialPageRoute(builder: (context) => LocationPicker()));
    Placemark placemark = await getPlaceMarkfromCoordinates(result);
    addressController.text =  "${placemark.street}, ${placemark.locality}";
    setState(() {
      eventLocation = result;

    });
  }

  Future<Placemark> getPlaceMarkfromCoordinates(LatLng point) async {
    return (await placemarkFromCoordinates(point.latitude, point.longitude))
        .reduce((value, element) => Placemark(
            street: (element.street.isEmpty) ? value.street : element.street,
            locality: (element.locality.isEmpty)
                ? value.locality
                : element.locality));
  }

  void resetForm(){
    ticketsController.clear();
    nameController.clear();
    creatorController.clear();
    addressController.clear();
  }
}
