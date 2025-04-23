import 'dart:math';
import 'package:dishedout/models/user_model.dart';
import 'package:flutter/material.dart';

class Avatar extends StatelessWidget {
  final UserModel? user;
  const Avatar({super.key, required this.user});

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
        (user?.displayName != null && user!.displayName.isNotEmpty)
            ? user!.displayName![0].toUpperCase()
            : (user?.email[0].toUpperCase() ?? 'U'),
      ),
    );
  }
}
