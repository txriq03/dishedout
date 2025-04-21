import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dishedout/services/auth.dart';
import 'dart:io';

class PostService {
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
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
      final imageRef = _storage.ref().child('images/posts/$uid/$fileName.jpg');
      await imageRef.putFile(imageFile);

      // 2. Get download URL
      final downloadUrl = await imageRef.getDownloadURL();

      // 3. Attempt Firestore write
      await _firestore.collection('posts').add({
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
        await _storage.ref().child('images/posts/$uid/$fileName.jpg').delete();
        print('Image deleted due to Firestore write failure.');
      } catch (deleteError) {
        print('Error deleting image: $deleteError');
      }
    }
  }

  Future<List<Map<String, dynamic>>> getPosts() async {
    try {
      final snapshot = await _firestore.collection('posts').get();
      return snapshot.docs.map((doc) => doc.data()).toList();
    } catch (e) {
      print('Error fetching posts: $e');
      return [];
    }
  }
}
