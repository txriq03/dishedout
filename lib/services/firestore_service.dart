import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final FirebaseFirestore db = FirebaseFirestore.instance;

  Future<void> addUser(String uid, String name, String email) async {
    try {
      await db.collection('users').doc(uid).set({
        'name': name,
        'email': email,
        'createdAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      print('Error adding user: $e');
    }
  }

  Future<void> addFood(
    String uid,
    String name,
    String description,
    String imageUrl,
  ) async {
    try {
      await db.collection('foods').add({
        'uid': uid,
        'name': name,
        'description': description,
        'imageUrl': imageUrl,
        'createdAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      print('Error adding food: $e');
    }
  }
}
