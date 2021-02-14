
import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:free_radar/location_picker.dart';
import 'rap_events.dart';
import 'package:free_radar/create_event.dart';
import 'package:firebase_core/firebase_core.dart';


import 'map.dart';

const MAP_INDEX = 1;
const CREATE_EVENT = 0;
const FAVORITES = 2;

void main() async {
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp();
    runApp(MyApp());
}

class MyApp extends StatelessWidget {

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {

    return BlocProvider(
      blocs: [
        Bloc((_) => EventBloc() )
      ],
      child: MaterialApp(
          title: 'Marker Popup Demo',
          theme: ThemeData(
            primarySwatch: Colors.deepOrange,
          ),
          home: DisplayManager()
      ),
    );
  }
}

class DisplayManager extends StatefulWidget {


  DisplayManager({Key key}) : super(key: key);
  @override
  _DisplayManagerState createState() => _DisplayManagerState();
}

class _DisplayManagerState extends State<DisplayManager> {


   GlobalKey<MapPageState> mapKey = new GlobalKey<MapPageState>();
   int _screenSelected = 1;


   List<Widget> _screens = [];

   _DisplayManagerState(){

     this._screens = [CreateEventForm(),MapPage(mapKey),LocationPicker()];
   }


   void _onItemTapped(int index){
      setState(() {
        this._screenSelected = index;
      });
   }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Marker Popup Demo"),
      ),

      body: IndexedStack(
        index:_screenSelected,
        children: _screens,
      ),

      bottomNavigationBar: BottomNavigationBar(

          items: const <BottomNavigationBarItem> [
            BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: 'Home'
            ),
            BottomNavigationBarItem(

                icon:Icon(Icons.map),
                label: 'Map'
            ),
            BottomNavigationBarItem(
                icon:Icon(Icons.favorite),
                label: 'Favorites'
            )
          ],
        currentIndex: _screenSelected,
        unselectedItemColor: Colors.black,
        selectedItemColor: Colors.red[800],
        onTap: _onItemTapped
      ),
    );
  }
}








