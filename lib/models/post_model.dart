import 'package:cloud_firestore/cloud_firestore.dart';

class Post {
  final String uid;
  final String name;
  final String description;
  final String imageUrl;
  final String addressDescription;
  final double latitude;
  final double longitude;
  final String status;

  Post({
    required this.uid,
    required this.name,
    required this.description,
    required this.imageUrl,
    required this.addressDescription,
    required this.latitude,
    required this.longitude,
    this.status = 'available',
  });

  factory Post.fromMap(String id, Map<String, dynamic> data) {
    final address = data['address'] ?? {};
    return Post(
      uid: data['uid'] ?? '',
      name: data['name'] ?? '',
      description: data['description'] ?? '',
      imageUrl: data['imageUrl'] ?? '',
      addressDescription: address['addressDescription'] ?? '',
      latitude: (address['latitude'] as num?)?.toDouble() ?? 0.0,
      longitude: (address['longitude'] as num?)?.toDouble() ?? 0.0,
      status: data['status'] ?? 'available',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'name': name,
      'description': description,
      'imageUrl': imageUrl,
      'createdAt': FieldValue.serverTimestamp(),
      'status': status,
      'address': {
        'description': addressDescription,
        'latitude': latitude,
        'longitude': longitude,
      },
    };
  }
}
