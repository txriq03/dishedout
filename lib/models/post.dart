import 'package:cloud_firestore/cloud_firestore.dart';

class Post {
  final String uid;
  final String name;
  final String description;
  final String imageUrl;
  final DateTime createdAt;

  Post({
    required this.uid,
    required this.name,
    required this.description,
    required this.imageUrl,
    required this.createdAt,
  });

  factory Post.fromMap(Map<String, dynamic> data) {
    return Post(
      uid: data['uid'] ?? '',
      name: data['name'] ?? '',
      description: data['description'] ?? '',
      imageUrl: data['imageUrl'] ?? '',
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'name': name,
      'description': description,
      'imageUrl': imageUrl,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }
}
