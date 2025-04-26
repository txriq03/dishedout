import 'package:dishedout/models/post_model.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dishedout/services/auth.dart';
import 'dart:io';

import 'package:flutter/material.dart';

class PostService {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseStorage storage = FirebaseStorage.instance;
  final Auth _auth = Auth();
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

    final fileName =
        DateTime.now().millisecondsSinceEpoch
            .toString(); // Moved outside the try block

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

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'You have claimed this item! Collect it at the pick-up location',
              ),
            ),
          );
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
}
