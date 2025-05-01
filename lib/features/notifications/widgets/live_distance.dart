import 'package:flutter/material.dart';

class DistanceDisplay extends StatelessWidget {
  final Stream<double> distanceStream;

  const DistanceDisplay({super.key, required this.distanceStream});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<double>(
      stream: distanceStream,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Text("Waiting for distance...");
        }

        double distance = snapshot.data!;

        String distanceText;
        if (distance >= 1000) {
          distanceText = "${(distance / 1000).toStringAsFixed(2)} km away";
        } else {
          distanceText = "${distance.toStringAsFixed(0)} meters away";
        }

        return Card(
          margin: EdgeInsets.all(16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              children: [
                Icon(Icons.directions_walk, size: 40, color: Colors.blueAccent),
                SizedBox(width: 20),
                Expanded(
                  child: Text(
                    "Claimer is $distanceText",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
