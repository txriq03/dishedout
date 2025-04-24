import 'dart:async';
import 'package:url_launcher/url_launcher.dart';
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
  bool _isMounted = true;
  StreamSubscription<Position>? _positionStream;
  bool _notified = false;

  @override
  void initState() {
    super.initState();
    _isMounted = true;
    _initLocationTracking();
  }

  @override
  void dispose() {
    _isMounted = false;
    _positionStream?.cancel();
    mapController.dispose();
    super.dispose();
  }

  // Launch Google Maps for navigation
  void _launchExternalNavigation(LatLng destination) async {
    final Uri url = Uri.parse(
      'https://www.google.com/maps/dir/?api=1&destination=${destination.latitude},${destination.longitude}&travelmode=driving',
    );

    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } else {
      throw 'Could not launch Google Maps';
    }
  }

  void _initLocationTracking() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) return;

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    _positionStream = Geolocator.getPositionStream(
      locationSettings: LocationSettings(accuracy: LocationAccuracy.best),
    ).listen((Position position) {
      if (_isMounted) {
        setState(() {
          claimerPosition = LatLng(position.latitude, position.longitude);
        });
      }
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

    if (distance < 100 && !_notified) {
      // Send notification here
      _notified = true;
      _sendArrivalNotification();
    }
  }

  void _sendArrivalNotification() {
    // Implement your notification logic here
    print("User has arrived at the drop-off location!");
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GoogleMap(
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
        ),
        Positioned(
          bottom: 16,
          left: 16,
          right: 16,
          child: ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 20),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25),
              ),
            ),
            onPressed: () => _launchExternalNavigation(widget.lenderLocation),
            icon: Icon(Icons.navigation),
            label: Text('Navigate with Google Maps'),
          ),
        ),
      ],
    );
  }
}
