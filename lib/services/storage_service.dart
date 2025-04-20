import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';

class StorageService {
  final _storage = FirebaseStorage.instance;
  final postImagesRef = FirebaseStorage.instance.ref().child('images/posts');
  final profileImagesRef = FirebaseStorage.instance.ref().child(
    'images/profile',
  );

  Future<void> uploadImage({
    required File imageFile,
    required String uid,
  }) async {
    try {
      final fileName = DateTime.now().millisecondsSinceEpoch.toString();
      final imageRef = postImagesRef.child('$uid/$fileName.jpg');
      final uploadTask = await imageRef.putFile(File(imageFile));
    } catch (e) {
      print('Error uploading image: $e');
    }
  }
}
