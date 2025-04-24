import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';

class LiveTrackingMap extends StatefulWidget {
  final LatLng lenderLocation;
  const LiveTrackingMap({super.key, required this.lenderLocation});

  @override
  State<LiveTrackingMap> createState() => _LiveTrackingMapState();
}

class _LiveTrackingMapState extends State<LiveTrackingMap> {
  late GoogleMapController mapController;
  LatLng? claimerPosition;
  Set<Polyline> polylines = {};
  List<LatLng> polylineCoordinates = [];

  @override
  void initState() {
    super.initState();
    _initLocationTracking();
  }

  void _initLocationTracking() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) return;

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      // if (permission == LocationPermission.denied) return;
    }

    Geolocator.getPositionStream(
      locationSettings: LocationSettings(accuracy: LocationAccuracy.best),
    ).listen((Position position) {
      setState(() {
        claimerPosition = LatLng(position.latitude, position.longitude);
      });
      _updatePolyline();
      _checkProximity();
    });

    Future<void> _updatePolyline() async {
      if (claimerPosition == null) return;
      PolylinePoints polylinePoints = PolylinePoints();
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
