import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:free_radar/model/event.dart';

import 'map/utils/icons.dart';


class EventPopup extends StatelessWidget {
  final EventMarker event;

  EventPopup(Marker event):event = event as EventMarker;


  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            _cardDescription(context),
          ],
        ),
        onTap: () => print("on tap"),
      ),
    );
  }

  Widget _cardDescription(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Container(
        constraints: BoxConstraints(minWidth: 100, maxWidth: 200),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(
              event.model.nombre,
              overflow: TextOverflow.fade,
              softWrap: false,
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 14.0,
              ),
            ),
            const Padding(padding: EdgeInsets.symmetric(vertical: 4.0)),
            Text(
              "Creador: ${event.model.creador}",
              style: const TextStyle(fontSize: 12.0),
            ),
            Text(
              "Cupos: ${event.model.cupos}",
              style: const TextStyle(fontSize: 12.0),
            ),
          ],
        ),
      ),
    );
  }
}


