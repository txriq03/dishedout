import 'package:dishedout/models/user_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final currentUserProvider = FutureProvider<UserModel?>((ref) async {
  final user = FirebaseAuth.instance.currentUser;

  if (user == null) return null;

  final doc =
      await FirebaseFirestore.instance.collection('users').doc(user.uid).get();

  if (!doc.exists) return null;

  return UserModel.fromDocument(doc);
});
