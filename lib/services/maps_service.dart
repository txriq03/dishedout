import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapService {
  Stream<double> getDistanceStream(LatLng lenderLocation) {
    return Geolocator.getPositionStream(
      locationSettings: LocationSettings(accuracy: LocationAccuracy.best),
    ).map((position) {
      // Calculate distance
      return Geolocator.distanceBetween(
        position.latitude,
        position.longitude,
        lenderLocation.latitude,
        lenderLocation.longitude,
      );
    });
  }
}
