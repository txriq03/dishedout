import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapService {
  final LocationSettings locationSettings = AndroidSettings(
    accuracy: LocationAccuracy.best,
    distanceFilter: 10,
    foregroundNotificationConfig: ForegroundNotificationConfig(
      notificationTitle: 'Location Tracking Active',
      notificationText: 'Tracking your location for lender...',
    ),
  );
  MapService();

  Stream<double> getDistanceStream(LatLng lenderLocation) {
    return Geolocator.getPositionStream(locationSettings: locationSettings).map(
      (position) {
        // Calculate distance
        return Geolocator.distanceBetween(
          position.latitude,
          position.longitude,
          lenderLocation.latitude,
          lenderLocation.longitude,
        );
      },
    );
  }
}
