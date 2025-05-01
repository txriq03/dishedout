import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String uid;
  final String displayName;
  final String email;
  final String imageUrl;
  final String fcmToken;
  final String? claimedPost;
  final DateTime createdAt;

  UserModel({
    required this.uid,
    required this.displayName,
    this.claimedPost = '',
    this.imageUrl = '',
    required this.email,
    required this.fcmToken,
    required this.createdAt,
  });

  // Convert Firestore doc to UserModel
  factory UserModel.fromDocument(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return UserModel(
      uid: doc.id,
      displayName: data['displayName'] ?? '',
      email: data['email'] ?? '',
      imageUrl: data['imageUrl'] ?? '',
      claimedPost: data['claimedPost'] ?? '',
      fcmToken: data['fcmToken'] ?? '',
      createdAt: (data['createdAt'] as Timestamp).toDate(),
    );
  }

  // Convert UserModel to Firestore map
  Map<String, dynamic> toMap() {
    return {
      'displayName': displayName,
      'email': email,
      'fcmToken': fcmToken,
      'imageUrl': imageUrl,
      'claimedPost': claimedPost,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }
}
