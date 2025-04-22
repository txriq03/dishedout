import 'dart:math';
import 'package:dishedout/features/home/widgets/search_bar.dart';
import 'package:dishedout/features/home/widgets/uploads_carousel.dart';
import 'package:flutter/material.dart';
import 'package:dishedout/services/auth.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});
  final Auth _auth = Auth();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(80),
        child: AppBar(
          automaticallyImplyLeading: false, // Removes back button
          title: Padding(
            padding: EdgeInsets.only(top: 12.0),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 16,
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
                    style: const TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _auth.currentUser?.displayName ??
                          _auth.currentUser?.email ??
                          'User',
                      style: TextStyle(
                        color: Colors.grey[200],
                        fontSize: 21,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                  ],
                ),
              ],
            ),
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
