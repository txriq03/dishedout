import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dishedout/models/user_model.dart';

class UserService {
  final FirebaseFirestore firestore;
  UserService(this.firestore);

  Future<String?> getDisplayName(String uid) async {
    final doc = await firestore.collection('users').doc(uid).get();

    if (!doc.exists) return null;

    return doc.data()?['displayName'] as String?;
  }

  Future<void> addUser(String uid, String displayName, String email) async {
    try {
      await firestore.collection('users').doc(uid).set({
        'uid': uid,
        'displayName': displayName,
        'email': email,
        'createdAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      print('Error adding user: $e');
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
