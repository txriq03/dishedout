import 'dart:async';

import 'package:dishedout/models/user_model.dart';
import 'package:dishedout/services/user_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'user_provider.g.dart';

@riverpod
class UserNotifier extends _$UserNotifier {
  late final StreamSubscription<User?> _sub;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final UserService _userService = UserService();

  @override
  Future<UserModel?> build() async {
    _sub = _auth.authStateChanges().listen(
      (_) => ref.invalidateSelf(),
    ); // Provider rebuilds whenever auth state changes

    final user = _auth.currentUser;
    if (user == null) return null;

    return await _userService.getUser(user.uid);
  }
}
