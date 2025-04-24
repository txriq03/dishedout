import 'package:dishedout/constants.dart';
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
  final googleApiKey = AppConstants.googleApiKey;

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
  }

  // Redraw the polyline on the map
  Future<void> _updatePolyline() async {
    if (claimerPosition == null) return;
    PolylinePoints polylinePoints = PolylinePoints();
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      googleApiKey: googleApiKey,
      request: PolylineRequest(
        origin: PointLatLng(
          claimerPosition!.latitude,
          claimerPosition!.longitude,
        ),
        destination: PointLatLng(
          widget.lenderLocation.latitude,
          widget.lenderLocation.longitude,
        ),
        mode: TravelMode.driving,
      ),
    );

    if (result.points.isNotEmpty) {
      polylineCoordinates =
          result.points.map((p) => LatLng(p.latitude, p.longitude)).toList();
      setState(() {
        polylines = {
          Polyline(
            polylineId: const PolylineId("route"),
            points: polylineCoordinates,
            color: Colors.deepOrange,
            width: 5,
            startCap: Cap.roundCap,
          ),
        };
      });
    }
  }

  // Check if the claimer is within 100 meters of the lender's location
  void _checkProximity() {
    if (claimerPosition == null) return;
    double distance = Geolocator.distanceBetween(
      claimerPosition!.latitude,
      claimerPosition!.longitude,
      widget.lenderLocation.latitude,
      widget.lenderLocation.longitude,
    );

    if (distance < 100) {
      // Send notification here
      print("User is near the drop-off location!");
    }
  }

  @override
  Widget build(BuildContext context) {
    return GoogleMap(
      initialCameraPosition: CameraPosition(
        target: widget.lenderLocation,
        zoom: 14,
      ),
      onMapCreated: (controller) => mapController = controller,
      markers: {
        Marker(
          markerId: MarkerId("lender"),
          position: widget.lenderLocation,
          infoWindow: InfoWindow(title: "Lender"),
        ),
        if (claimerPosition != null)
          Marker(
            markerId: MarkerId("claimer"),
            position: claimerPosition!,
            infoWindow: InfoWindow(title: "Claimer"),
          ),
      },
      polylines: polylines,
      myLocationEnabled: true,
    );
  }
}
