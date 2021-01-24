import 'package:geolocator/geolocator.dart';

class GPSService {
  Future<Position> getCurrentLocation(){
    final Geolocator geolocator = Geolocator()..forceAndroidLocationManager;
    return geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.best);
  }
}