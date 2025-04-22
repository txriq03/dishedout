import 'package:cloud_firestore/cloud_firestore.dart';

class UserService {
  final FirebaseFirestore firestore;
  UserService(this.firestore);

  Future<String?> getDisplayName(String uid) async {
    final doc = await firestore.collection('users').doc(uid).get();

    if (!doc.exists) return null;

    return doc.data()?['displayName'] as String?;
  }
}
