import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String uid;
  final String displayName;
  final String email;
  final DateTime createdAt;

  UserModel({
    required this.uid,
    required this.displayName,
    required this.email,
    required this.createdAt,
  });

  // Convert Firestore doc to UserModel
  factory UserModel.fromDocument(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return UserModel(
      uid: doc.id,
      displayName: data['displayName'] ?? '',
      email: data['email'] ?? '',
      createdAt: (data['createdAt'] as Timestamp).toDate(),
    );
  }

  // Convert UserModel to Firestore map
  Map<String, dynamic> toMap() {
    return {
      'displayName': displayName,
      'email': email,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }
}
