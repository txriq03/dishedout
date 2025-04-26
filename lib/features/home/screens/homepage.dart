import 'package:dishedout/features/home/widgets/uploads_carousel.dart';
import 'package:dishedout/models/user_model.dart';
import 'package:dishedout/services/notification_service.dart';
import 'package:dishedout/services/user_service.dart';
import 'package:dishedout/shared/widgets/avatar.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:dishedout/services/auth.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final Auth _auth = Auth();
  final UserService _userService = UserService();

  @override
  void initState() {
    super.initState();

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      showLocalNotification(message);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actionsPadding: const EdgeInsets.only(right: 10),
        automaticallyImplyLeading: false, // Removes back button
        titleSpacing: 10,
        title: Row(
          children: [
            FutureBuilder<UserModel?>(
              future: _userService.getUser(_auth.currentUser!.uid),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator(); // or a placeholder avatar
                } else if (snapshot.hasError) {
                  return const Icon(Icons.error); // or handle error
                } else {
                  return Avatar(user: snapshot.data);
                }
              },
            ),
            SizedBox(width: 10),
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
