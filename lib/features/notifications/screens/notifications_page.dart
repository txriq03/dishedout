import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dishedout/models/notifications_model.dart';
import 'package:dishedout/services/maps_service.dart';
import 'package:dishedout/services/post_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:timeago/timeago.dart' as timeago;

class NotificationsPage extends StatelessWidget {
  final MapService _mapService = MapService();
  final User? currentUser = FirebaseAuth.instance.currentUser;
  NotificationsPage({super.key});

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
    final lat = address['latitude'];
    final lng = address['longitude'];

    if (lat == null || lng == null) return null;

    return LatLng(lat, lng);
  }

  @override
  Widget build(BuildContext context) {
    final String? userId = FirebaseAuth.instance.currentUser?.uid;

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
          // StreamBuilder(stream: _mapService.getDistanceStream(_getPostCoordinates()), builder: builder),
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

              return ListView.builder(
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
              );
            },
          ),
        ],
      ),
    );
  }
}
