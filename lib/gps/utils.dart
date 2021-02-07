import 'package:free_radar/map/utils/icons.dart';
import 'package:latlong/latlong.dart';

class LatLngData {
  const LatLngData(this.location, this.accuracy);

  final LatLng location;

  final double accuracy;

  bool highAccurency() {
    return !(accuracy == null || accuracy <= 0.0 || accuracy > 30.0);
  }
}
