import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:free_radar/map/utils/icons.dart';

class JoinInEvent extends StatelessWidget {
  final EventMarker marker;
  final _formKey = GlobalKey<FormState>();

  JoinInEvent({this.marker});


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(marker.model.nombre),
      ),
      body: SafeArea(
        child:buildForm(context)
      ),
    );
  }

  Widget buildForm(BuildContext context){
    return Form(
        key: _formKey,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              TextFormField(
                enabled: false,
                initialValue: marker.model.creador,
                key: UniqueKey(),
                decoration: const InputDecoration(
                    icon: Icon(Icons.account_balance),
                    hintText: '¿Cómo te llamas?',
                    labelText: 'Creador'),
              ),
              TextFormField(
                enabled: false,
                key: UniqueKey(),
                initialValue: marker.model.cupos.toString(),
                decoration: const InputDecoration(
                    icon: Icon(Icons.accessibility),
                    hintText: '¿Cuántos cupos tendrá?',
                    labelText: 'Cupos'),
                keyboardType: TextInputType.number,
              ),
              Container(
                margin: EdgeInsets.symmetric(vertical: 10, horizontal: 5),
                child: Center(
                  child: ElevatedButton(
                    onPressed: () async {

                      FirebaseFirestore.instance.runTransaction((transaction)  async {
                       if (await marker.model.buyTicket(transaction)){
                         Navigator.pop(context);
                       }
                      });


                    },
                    child: Text('Inscribirse'),
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}
