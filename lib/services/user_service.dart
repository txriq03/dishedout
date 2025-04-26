import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dishedout/models/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class UserService {
  final FirebaseFirestore firestore;
  UserService(this.firestore);

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
}
