import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:dishedout/models/post_model.dart';
import 'package:dishedout/providers/auth_provider.dart';
import 'package:dishedout/services/post_service.dart';

part 'notifications_provider.g.dart';

// Get post that the current user has claimed
@riverpod
Future<Post?> claimedPost(Ref ref) async {
  // Get current user
  final user = await ref.watch(authNotifierProvider.future);

  final claimedPostId = user?.claimedPost;
  if (claimedPostId == null || claimedPostId.isEmpty) return null;

  final postService = PostService();
  final postDoc = await postService.getPost(claimedPostId);
  if (postDoc == null || !postDoc.exists) return null;

  return Post.fromDocument(postDoc);
}
