import 'dart:async';

import 'package:dishedout/models/user_model.dart';
import 'package:dishedout/services/user_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'user_provider.g.dart';

@riverpod
class UserNotifier extends _$UserNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final UserService _userService = UserService();

  @override
  Future<UserModel?> build() async {
    final User? currentUser = _auth.currentUser;
    if (currentUser == null) return null;

    return await _userService.getUser(currentUser.uid);
  }
}
