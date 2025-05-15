import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dishedout/models/notifications_model.dart';
import 'package:dishedout/providers/claimed_post_with_distance_provider.dart';
import 'package:dishedout/services/maps_service.dart';
import 'package:dishedout/services/post_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:timeago/timeago.dart' as timeago;

class NotificationsPage extends ConsumerStatefulWidget {
  const NotificationsPage({super.key});

  @override
  ConsumerState<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends ConsumerState<NotificationsPage> {
  final MapService _mapService = MapService();
  final User? currentUser = FirebaseAuth.instance.currentUser;
  LatLng? lenderLocation;
  late Stream<double>? distanceStream;
  late double lat;
  late double lng;

  String _formatTimestamp(DateTime timestamp) {
    return timeago.format(timestamp);
  }

  Future<String?> _getClaimedPostId() async {
    String? userId = currentUser?.uid;
    if (userId == null) return null;
    final DocumentSnapshot data =
        await FirebaseFirestore.instance.collection('users').doc(userId).get();
    final String? claimedPostId = data['claimedPost'];

    if (claimedPostId == null || claimedPostId.isEmpty) return null;

    return claimedPostId;
  }

  // Get coordinates of the post the user has claimed
  Future<LatLng?> _getPostCoordinates() async {
    final PostService postService = PostService();
    final String? claimedPostId = await _getClaimedPostId();
    if (claimedPostId == null) return null;

    // Get lat and lng coordinates of post
    final DocumentSnapshot? post = await postService.getPost(claimedPostId);
    if (post == null || !post.exists) return null;

    final address = post['address'];
    lat = address['latitude'];
    lng = address['longitude'];

    return LatLng(lat, lng);
  }

  Future<void> _loadLenderLocation() async {
    final LatLng? location = await _getPostCoordinates();

    if (!mounted) return; // Prevent updating if widget is disposed

    setState(() {
      lenderLocation = location;
      if (lenderLocation != null) {
        distanceStream = _mapService.getDistanceStream(lenderLocation!);
      }
    });
  }

  String? distanceInMiles(double? distanceInMeters) {
    const double metersPerMile = 1609.34;

    if (distanceInMeters == null) return null;

    if (distanceInMeters >= metersPerMile) {
      final miles = distanceInMeters / metersPerMile;
      return '${miles.toStringAsFixed(2)} miles away';
    } else {
      return '${distanceInMeters.toStringAsFixed(0)} meters away';
    }
  }

  @override
  void initState() {
    super.initState();
    _loadLenderLocation();
  }

  @override
  Widget build(BuildContext context) {
    final String? userId = FirebaseAuth.instance.currentUser?.uid;
    final claimed = ref.watch(claimedPostWithDistanceProvider);
    final isLoading = claimed is AsyncLoading;
    final claimedData = claimed.asData?.value;

    if (userId == null) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Notifications', style: TextStyle(fontSize: 24)),
          centerTitle: true,
        ),
        body: const Center(child: Text('User not logged in.')),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Notifications', style: TextStyle(fontSize: 24)),
        centerTitle: true,
      ),
      body: Column(
        children: [
          if (!isLoading)
            StreamBuilder<double>(
              stream: claimedData?.distanceStream,
              builder: (context, snapshot) {
                if (snapshot.data != null) {
                  return Hero(
                    tag: 'distance-hero',
                    child: Card(
                      color: Theme.of(context).colorScheme.primary,
                      shadowColor: Theme.of(context).colorScheme.primary,
                      elevation: 5,
                      child: ListTile(
                        leading: const Icon(
                          Icons.info_rounded,
                          color: Colors.black,
                        ),
                        trailing: Container(
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(100),
                            color: Colors.white,
                          ),
                          child: Icon(Icons.arrow_forward_rounded),
                        ),
                        title: Text(
                          'Claimer is on his way!',
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        subtitle: Text(
                          'Distance: ${distanceInMiles(snapshot.data)}',
                          style: TextStyle(color: Colors.grey[900]),
                        ),
                      ),
                    ),
                  );
                }

                return Container(
                  height: 70,
                  margin: EdgeInsets.symmetric(horizontal: 4),
                  padding: EdgeInsets.symmetric(vertical: 10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: Theme.of(context).colorScheme.surfaceContainer,
                  ),
                  child: Center(
                    child: SizedBox(
                      height: 40,
                      width: 40,
                      child: CircularProgressIndicator(),
                    ),
                  ),
                );
              },
            ),
          StreamBuilder(
            stream:
                FirebaseFirestore.instance
                    .collection('users')
                    .doc(userId)
                    .collection('notifications')
                    .orderBy('createdAt', descending: true)
                    .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return const Center(child: Text('No notifications yet.'));
              }

              final notifications =
                  snapshot.data!.docs
                      .map((doc) => AppNotification.fromDocument(doc))
                      .toList();

              return Expanded(
                child: ListView.builder(
                  itemCount: notifications.length,
                  itemBuilder: (context, index) {
                    final notification = notifications[index];
                    return Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                      child: ListTile(
                        leading: const Icon(Icons.notifications_rounded),
                        title: Text(notification.title),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(notification.body),
                            Text(
                              _formatTimestamp(notification.createdAt),
                              style: TextStyle(
                                fontSize: 10,
                                color: Colors.white.withValues(alpha: 0.5),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
