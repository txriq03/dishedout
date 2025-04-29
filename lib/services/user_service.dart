import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dishedout/models/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;

class UserService {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  UserService();

  Future<String?> getDisplayName(String uid) async {
    final doc = await firestore.collection('users').doc(uid).get();

    if (!doc.exists) return null;

    return doc.data()?['displayName'] as String?;
  }

  Future<void> addUserToFirestore(User user) async {
    final userDoc = FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid);

    // Check if the user already exists
    final docSnapshot = await userDoc.get();
    if (!docSnapshot.exists) {
      String? token = await FirebaseMessaging.instance.getToken();

      final newUser = UserModel(
        uid: user.uid,
        displayName: user.displayName ?? '',
        email: user.email ?? '',
        fcmToken: token ?? '',
        createdAt: DateTime.now(),
      );

      try {
        await userDoc.set(newUser.toMap());
      } catch (e) {
        print('Error adding user: $e');
      }
    } else {
      print('User already exists in Firestore.');
    }
  }

  Future<UserModel?> getUser(String uid) async {
    try {
      final doc = await firestore.collection('users').doc(uid).get();
      if (doc.exists) {
        return UserModel.fromDocument(doc);
      }
    } catch (e) {
      print('Error fetching user: $e');
    }
    return null;
  }

  Future<void> uploadImage() async {
    try {
      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(source: ImageSource.gallery);

      if (pickedFile == null) {
        print('No image selected');
        return;
      }

      final File file = File(pickedFile.path);
      final ext = path.extension(file.path); // Get file extension (e.g. '.jpg')

      final userId = FirebaseAuth.instance.currentUser!.uid;
      final storageRef = _storage
          .ref()
          .child('profile_pictures')
          .child('$userId$ext');

      // Upload image
      await storageRef.putFile(file);

      // Get URL
      final downloadUrl = await storageRef.getDownloadURL();

      // Update Firestore user doc
      await firestore.collection('users').doc(userId).update({
        'imageUrl': downloadUrl,
      });

      print('Profile picture updated!');
    } catch (e) {
      print('Failed to upload image: $e');
    }
  }
}
