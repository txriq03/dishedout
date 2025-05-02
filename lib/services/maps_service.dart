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

  Future<bool> _checkLocationPermission() async {
    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      // Permissions are still denied so cannot continue
      return false;
    }

    return true;
  }

  Stream<double> getDistanceStream(LatLng lenderLocation) async* {
    bool hasPermission = await _checkLocationPermission();

    if (!hasPermission) {
      yield* Stream.empty();
      return;
    }

    yield* Geolocator.getPositionStream(locationSettings: locationSettings).map(
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

  Future<double?> getInitialDistance(double lenderLat, double lenderLng) async {
    bool hasPermission = await _checkLocationPermission();

    if (!hasPermission) {
      return null;
    }
    Position currentPosition = await Geolocator.getCurrentPosition();

    final double initialDistance = Geolocator.distanceBetween(
      currentPosition.latitude,
      currentPosition.longitude,
      lenderLat,
      lenderLng,
    );

    return initialDistance;
  }
}
