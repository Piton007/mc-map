import 'package:flutter/material.dart';
import 'package:free_radar/location_picker.dart';
import 'package:latlong/latlong.dart';

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
  LatLng eventLocation;
  String address = "Calle Victor Humareda mzn x lote 21";

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
                        onTap: () => print("hello"),
                        initialValue: address,
                        validator: (value) {
                          var result;
                          if (value.isEmpty) {
                            result = 'Selecciona la ubicación de tu evento';
                          }

                          return result;
                        },
                      ),
                      flex: 2),
                  Expanded(child: IconButton(
                    icon: Icon(Icons.edit),
                    onPressed: ()=>navigateToLocationPicker(context),
                  ))
                ],
              ),
              Container(
                margin: EdgeInsets.symmetric(vertical: 10, horizontal: 5),
                child: Center(
                  child: ElevatedButton(
                    onPressed: () {
                      // Validate returns true if the form is valid, or false
                      // otherwise.

                      if (_formKey.currentState.validate()) {
                        // If the form is valid, display a Snackbar.
                        Scaffold.of(context).showSnackBar(
                            SnackBar(content: Text('Processing Data')));
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


  Future<void> navigateToLocationPicker(BuildContext context) async {
   LatLng result = await Navigator.push(context,MaterialPageRoute(builder: (context) => LocationPicker()));
   setState(() {
      print(result);
      address = "hey";
   });
  }
}
