import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';

class LiveClaimerDistanceWidget extends StatefulWidget {
  final LatLng lenderLocation;
  final Stream<LatLng> claimerLocationStream;

  const LiveClaimerDistanceWidget({
    super.key,
    required this.lenderLocation,
    required this.claimerLocationStream,
  });

  @override
  State<LiveClaimerDistanceWidget> createState() =>
      _LiveClaimerDistanceWidgetState();
}

class _LiveClaimerDistanceWidgetState extends State<LiveClaimerDistanceWidget> {
  late StreamSubscription<LatLng> _claimerLocationSubscription;
  double? distanceInMeters;

  @override
  void initState() {
    super.initState();

    // Listen to the live claimer location stream
    _claimerLocationSubscription = widget.claimerLocationStream.listen((
      claimerLocation,
    ) {
      double distance = Geolocator.distanceBetween(
        claimerLocation.latitude,
        claimerLocation.longitude,
        widget.lenderLocation.latitude,
        widget.lenderLocation.longitude,
      );

      setState(() {
        distanceInMeters = distance;
      });
    });
  }

  @override
  void dispose() {
    _claimerLocationSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Row(
          children: [
            Icon(Icons.directions_walk, size: 40, color: Colors.blueAccent),
            SizedBox(width: 20),
            Expanded(
              child: Text(
                distanceInMeters == null
                    ? "Waiting for claimer location..."
                    : distanceInMeters! >= 1000
                    ? "Claimer is ${(distanceInMeters! / 1000).toStringAsFixed(2)} km away"
                    : "Claimer is ${distanceInMeters!.toStringAsFixed(0)} meters away",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
