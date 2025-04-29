import 'dart:math';
import 'package:dishedout/models/user_model.dart';
import 'package:flutter/material.dart';

class Avatar extends StatelessWidget {
  final UserModel? user;
  final double radius;
  final double fontSize;
  const Avatar({
    super.key,
    required this.user,
    this.radius = 18,
    this.fontSize = 12,
  });

  @override
  Widget build(BuildContext context) {
    final String? imageUrl = user?.imageUrl;
    if (imageUrl != null && imageUrl.isNotEmpty) {
      return CircleAvatar(
        radius: radius,
        backgroundImage: NetworkImage(imageUrl),
        backgroundColor: Colors.grey.shade300,
      );
    }

    return CircleAvatar(
      radius: radius,
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
            ? user!.displayName[0].toUpperCase()
            : (user?.email[0].toUpperCase() ?? 'U'),
        style: TextStyle(fontSize: fontSize),
      ),
    );
  }
}
