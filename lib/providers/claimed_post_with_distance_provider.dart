import 'package:dishedout/services/maps_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:dishedout/models/post_model.dart';
import 'package:dishedout/providers/auth_provider.dart';
import 'package:dishedout/services/post_service.dart';

part 'claimed_post_with_distance_provider.g.dart';

class ClaimedPostWithDistance {
  final Post post;
  final Stream<double> distanceStream;

  ClaimedPostWithDistance({required this.post, required this.distanceStream});
}

// Get current user's claimed post and distance to pick-up
@riverpod
Future<ClaimedPostWithDistance?> claimedPostWithDistance(Ref ref) async {
  final user = await ref.watch(authNotifierProvider.future);
  final claimedPostId = user?.claimedPost;
  if (claimedPostId == null || claimedPostId.isEmpty) return null;

  final postDoc = await PostService().getPost(claimedPostId);
  if (postDoc == null || !postDoc.exists) return null;

  final post = Post.fromDocument(postDoc);
  final location = LatLng(post.latitude, post.longitude);
  final stream = MapService().getDistanceStream(location);

  return ClaimedPostWithDistance(post: post, distanceStream: stream);
}
