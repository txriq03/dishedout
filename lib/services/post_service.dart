import 'package:dishedout/models/post.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dishedout/services/auth.dart';
import 'dart:io';

class PostService {
  final FirebaseFirestore firestore;
  final FirebaseStorage storage;

  PostService(this.firestore, this.storage);
  final Auth _auth = Auth();

  Future<void> uploadPost({
    required File imageFile,
    required String name,
    required String description,
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

      // 3. Attempt Firestore write
      await firestore.collection('posts').add({
        'uid': uid,
        'name': name,
        'description': description,
        'imageUrl': downloadUrl,
        'createdAt': FieldValue.serverTimestamp(),
      });
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
          .map((doc) => Post.fromMap(doc.data()))
          .toList(); // List of posts
    } catch (e) {
      print('Error fetching posts: $e');
      return [];
    }
  }
}
