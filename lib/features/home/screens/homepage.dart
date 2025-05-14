import 'package:dishedout/features/home/widgets/subscribe_banner.dart';
import 'package:dishedout/features/home/widgets/uploads_carousel.dart';
import 'package:dishedout/features/notifications/screens/notifications_page.dart';
import 'package:dishedout/providers/auth_provider.dart';
import 'package:dishedout/shared/widgets/avatar.dart';
import 'package:flutter/material.dart';
import 'package:dishedout/services/auth_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  final AuthService _auth = AuthService();

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authNotifierProvider);
    return Scaffold(
      appBar: AppBar(
        actionsPadding: const EdgeInsets.only(right: 10),
        automaticallyImplyLeading: false, // Removes back button
        titleSpacing: 10,
        title: Row(
          children: [
            authState.when(
              loading: () => const CircularProgressIndicator(),
              error: (e, _) => const Icon(Icons.error_rounded),
              data: (user) {
                return Avatar(user: user);
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
            onPressed: () {
              // Navigate to login
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => NotificationsPage()),
              );
            },
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
              SizedBox(height: 5),
              SubscribeBanner(),
            ],
          ),
        ),
      ),
    );
  }
}
