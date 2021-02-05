import 'dart:async';

import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class EventBloc extends BlocBase {
  Stream<QuerySnapshot> _events;

  EventBloc(){
       _events = FirebaseFirestore.instance.collection("rap_events").snapshots().asBroadcastStream();
  }

  Stream<QuerySnapshot> get stream {return this._events;}

}





