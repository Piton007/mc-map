import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_marker_popup/extension_api.dart';
import 'package:free_radar/joinin_event.dart';


import 'map/utils/icons.dart';


class EventPopup extends StatelessWidget {
  final EventMarker event;
  final PopupController popupController;

  EventPopup(Marker event, PopupController popupController):event = event, popupController = popupController;


  @override
  Widget build(BuildContext context) {
    return Card(
      color: (event.model.isAvailable() ) ? Colors.white : Colors.deepOrange,
      child: InkWell(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            _cardDescription(context),
          ],
        ),
        onTap: ()=> (event.model.isAvailable() ) ?  showEvent(context): null,
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

  Future<void> showEvent(BuildContext context) async {
    await Navigator.push(context, MaterialPageRoute(builder: (context) => JoinInEvent(marker: this.event)));
    this.popupController.hidePopup();
  }
}


