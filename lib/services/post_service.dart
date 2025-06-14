import 'package:dishedout/models/post_model.dart';
import 'package:dishedout/services/notification_service.dart';
import 'package:dishedout/services/user_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dishedout/services/auth_service.dart';
import 'dart:io';
import 'package:flutter/material.dart';

class PostService {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseStorage storage = FirebaseStorage.instance;
  final AuthService _auth = AuthService();
  PostService();

  Future<void> uploadPost({
    required File imageFile,
    required String name,
    required String description,
    required String addressDescription,
    required double? lat,
    required double? lng,
  }) async {
    final user = _auth.currentUser;
    if (user == null) {
      // Handle user not logged in
      print('User not logged in!');
      return;
    }
    final uid = user.uid;

    final fileName = DateTime.now().millisecondsSinceEpoch.toString();

    try {
      // 1. Upload post image
      final imageRef = storage.ref().child('images/posts/$uid/$fileName.jpg');
      await imageRef.putFile(imageFile);

      // 2. Get download URL
      final downloadUrl = await imageRef.getDownloadURL();

      // 3. Create Firestore doc reference to get ID
      final postRef = firestore.collection('posts').doc();

      // 4. Attempt Firestore write
      final post = Post(
        id: postRef.id,
        uid: uid,
        name: name,
        description: description,
        imageUrl: downloadUrl,
        addressDescription: addressDescription,
        latitude: lat ?? 0.0,
        longitude: lng ?? 0.0,
      );
      await firestore.collection('posts').add(post.toMap());
      print('Post uploaded successfully!');
    } catch (e) {
      print('Error uploading post: $e');

      // Delete the image if Firestore write fails
      try {
        await storage.ref().child('images/posts/$uid/$fileName.jpg').delete();
        print('Image deleted due to Firestore write failure.');
      } catch (deleteError) {
        print('Error deleting image: $deleteError');
      }
    }
  }

  Future<DocumentSnapshot?> getPost(String? postId) async {
    if (postId == null) return null;

    return firestore.collection('posts').doc(postId).get();
  }

  Future<List<Post>> getPosts() async {
    try {
      final collection = await firestore.collection('posts').get();
      return collection.docs
          .map((doc) => Post.fromDocument(doc))
          .toList(); // List of posts
    } catch (e) {
      print('Error fetching posts: $e');
      return [];
    }
  }

  Future<void> updateStatus(
    BuildContext context,
    String postId,
    String updatedStatus,
  ) async {
    try {
      final postRef = firestore.collection('posts').doc(postId);
      switch (updatedStatus) {
        case 'claimed':
          await postRef.update({'status': 'claimed'});
          break;
        case 'unavailable':
          await postRef.update({'status': 'unavailable'});
          break;
        default:
          throw Exception('Invalid status: $updatedStatus');
      }
    } catch (e) {
      print('Failed to claim post: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to claim post: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> claimItem(BuildContext context, Post post) async {
    final String? claimerName = FirebaseAuth.instance.currentUser?.displayName;
    final UserService userService = UserService();

    final lenderDoc = await firestore.collection('users').doc(post.uid).get();
    final fcmToken = lenderDoc['fcmToken'];

    await updateStatus(context, post.id, 'claimed');
    await userService.updateClaimedPost(post.id);

    if (fcmToken != null) {
      print("Running notifyLender!");
      await notifyLender(
        token: fcmToken,
        title: 'Your food has been claimed!',
        body: '$claimerName just claimed your item: ${post.name}',
      );
    }
  }
}
