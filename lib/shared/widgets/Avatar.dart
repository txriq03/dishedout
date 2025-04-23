import 'dart:math';

import 'package:dishedout/services/auth.dart';
import 'package:flutter/material.dart';

class Avatar extends StatelessWidget {
  final User? currentUser;
  const Avatar({super.key, required this.currentUser});

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: 18,
      backgroundColor:
          ([
            Colors.deepOrange.shade300,
            Colors.blue.shade300,
            Colors.green.shade300,
            Colors.purple.shade300,
            Colors.teal.shade300,
          ]..shuffle(Random())).first,
      child: Text(
        (currentUser?.displayName != null &&
                currentUser!.displayName!.isNotEmpty)
            ? currentUser!.displayName![0].toUpperCase()
            : (currentUser?.email?[0].toUpperCase() ?? 'U'),
      ),
    );
  }
}
