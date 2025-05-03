import 'package:dishedout/features/home/widgets/subscribe_banner.dart';
import 'package:dishedout/features/home/widgets/uploads_carousel.dart';
import 'package:dishedout/features/notifications/screens/notifications_page.dart';
import 'package:dishedout/shared/widgets/avatar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dishedout/features/authentication/providers/user_provider.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUserAsync = ref.watch(currentUserProvider);

    return Scaffold(
      appBar: AppBar(
        actionsPadding: const EdgeInsets.only(right: 10),
        automaticallyImplyLeading: false,
        titleSpacing: 10,
        title: currentUserAsync.when(
          loading: () => const CircularProgressIndicator(),
          error: (error, stack) => const Text("User"),
          data:
              (currentUser) => Row(
                children: [
                  Avatar(user: currentUser),
                  const SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text.rich(
                        TextSpan(
                          text:
                              currentUser?.displayName ??
                              currentUser?.email ??
                              'User',
                          children: const [
                            WidgetSpan(
                              child: Icon(
                                Icons.chevron_right_rounded,
                                weight: 100,
                              ),
                            ),
                          ],
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
            onPressed: () {},
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
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => NotificationsPage()),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
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
