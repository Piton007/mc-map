import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_marker_popup/extension_api.dart';
import 'package:flutter_map_marker_popup/flutter_map_marker_popup.dart';
import "package:latlong/latlong.dart";
import "package:free_radar/popupMarker.dart";




void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final wordPair = WordPair.random();
    return MaterialApp(
      title: 'Welcome to Flutter',
      theme:ThemeData(
        primaryColor: Colors.deepOrangeAccent
      ),
      home: FreeMap()
    );
  }
}

class FreeMap extends StatelessWidget {
  final PopupController _popupController = PopupController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Free Map')
      ),
      body: Stack(children: <Widget>[
        new FlutterMap(options: new MapOptions(
            zoom:13.0,
            maxZoom: 18.0,
            center:  new LatLng( -12.046374, -77.042793),
            onTap: (_)=> _popupController.hidePopup(),
          plugins: [ PopupMarkerPlugin() ]
        ),
            layers: [
              new TileLayerOptions(
                  urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                  subdomains: ['a','b','c']),
              PopupMarkerLayerOptions(
                markers: [
                  new Marker(
                      width: 50,height: 80.0,
                      point: new LatLng( -12.046374, -77.042793),
                      builder: (context)=>
                      new Container(
                        child: new FlutterLogo(),
                      ))],
                popupSnap: PopupSnap.top,
                popupController: _popupController,
                popupBuilder: (BuildContext _, Marker marker) => PopupMaker(marker)


              )

            ])
      ],)
    );
  }
}



class RandomWords extends StatefulWidget {
  @override
  _RandomWordsState createState() => _RandomWordsState();
}

class _RandomWordsState extends State<RandomWords> {
  final List<WordPair> _sugg = <WordPair>[];
  final _saved = Set<WordPair>();
  final TextStyle _biggerFont = const TextStyle(fontSize: 18);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:  const Text('Startup Name Generator'),
        actions: [
          IconButton(icon:Icon(Icons.list),onPressed: _pushSaved,)
        ],
      ),
      body: _buildSuggestions(),
    );
  }

  void _pushSaved(){
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (BuildContext context) {
          final tiles = _saved.map(
              (WordPair pair) => ListTile(
                title: Text(
                  pair.asPascalCase,
                  style: _biggerFont,
                )
              )
          );
          final divided = ListTile.divideTiles(
            context:context,
            tiles:tiles
          ).toList();
          return Scaffold(
            appBar: AppBar(
              title: Text('Saved Suggestions'),
            ),
              body:ListView(children: divided)

          );
        }
      )
    );
  }

  Widget _buildSuggestions(){
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemBuilder: (BuildContext _context, int i){
        if (i.isOdd){
          return Divider();
        }
        final int index = i ~/ 2;
        if (isReachedToEnd(index)){
          _sugg.addAll(generateWordPairs().take(10));
        }
        return _buildRow(_sugg[index]);
      },

    );
  }
  Widget _buildRow(WordPair pair){
    final alreadySaved = _saved.contains(pair);
      return ListTile(
        title: Text(
          pair.asPascalCase,
          style:_biggerFont
        ),
        trailing: Icon(
          alreadySaved ? Icons.favorite : Icons.favorite_border,
          color: alreadySaved ? Colors.red : null,
        ),
        onTap:  (){
          setState(() {
            if (alreadySaved){
              _saved.remove(pair);
            }else{
              _saved.add(pair);
            }
          });
        },
      );
  }
  bool isReachedToEnd(int i){
      return i >= _sugg.length;
  }
}
