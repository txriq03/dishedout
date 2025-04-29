import 'package:cloud_firestore/cloud_firestore.dart';

class NotificationModel {
  final String id;
  final String title;
  final String body;
  final FieldValue createdAt;

  NotificationModel({
    required this.id,
    required this.title,
    required this.body,
    required this.createdAt,
  });

  factory NotificationModel.fromDocument(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    return NotificationModel(
      id: doc.id,
      title: data['title'] ?? '',
      body: data['body'] ?? '',
      createdAt: data['createdAt'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'body': body,
      'createdAt': FieldValue.serverTimestamp(),
    };
  }
}
