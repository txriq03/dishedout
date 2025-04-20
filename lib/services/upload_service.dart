import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:io';

class UploadService {
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> uploadPost({
    required File imageFile,
    required String uid,
    required String name,
    required String description,
  }) async {
    try {
      // 1. Upload post image
      final fileName = DateTime.now().millisecondsSinceEpoch.toString();
      final imageRef = _storage.ref().child('images/posts/$uid/$fileName.jpg');
      await imageRef.putFile(imageFile);

      // 2. Get download URL
      final downloadUrl = await imageRef.getDownloadURL();

      // 2. Attempt Firstore write
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
}
