import 'dart:math';
import 'package:dishedout/features/home/widgets/uploads_carousel.dart';
import 'package:flutter/material.dart';
import 'package:dishedout/services/auth.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});
  final Auth _auth = Auth();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actionsPadding: const EdgeInsets.only(right: 10),
        automaticallyImplyLeading: false, // Removes back button
        titleSpacing: 10,
        title: Row(
          children: [
            CircleAvatar(
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
                (_auth.currentUser?.displayName != null &&
                        _auth.currentUser!.displayName!.isNotEmpty)
                    ? _auth.currentUser!.displayName![0].toUpperCase()
                    : (_auth.currentUser?.email?[0].toUpperCase() ?? 'U'),
              ),
            ),
            const SizedBox(width: 10),
            Column(
              children: [
                Text.rich(
                  TextSpan(
                    text:
                        _auth.currentUser?.displayName ??
                        _auth.currentUser?.email ??
                        'User',
                    children: [
                      WidgetSpan(
                        child: Icon(Icons.chevron_right_rounded, weight: 100),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),

        actions: [
          IconButton.filled(
            icon: const Icon(Icons.search_rounded),
            tooltip: 'Search',
            style: ButtonStyle(
              backgroundColor: WidgetStateProperty.resolveWith((states) {
                if (states.isEmpty) {
                  return Theme.of(context).colorScheme.surfaceContainer;
                }
                return null;
              }),
              foregroundColor: WidgetStateProperty.resolveWith((states) {
                if (states.isEmpty) {
                  return Colors.deepOrange.shade300;
                }
                return null;
              }),
            ),
            onPressed: () async {},
          ),
          IconButton.filled(
            icon: const Icon(Icons.notifications_rounded),
            tooltip: 'Notifications',
            style: ButtonStyle(
              backgroundColor: WidgetStateProperty.resolveWith((states) {
                if (states.isEmpty) {
                  return Theme.of(context).colorScheme.surfaceContainer;
                }
                return null;
              }),
              foregroundColor: WidgetStateProperty.resolveWith((states) {
                if (states.isEmpty) {
                  return Colors.deepOrange.shade300;
                }
                return null;
              }),
            ),
            onPressed: () async {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Discover",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.w300),
              ),
              UploadsCarousel(),
            ],
          ),
        ),
      ),
    );
  }
}
