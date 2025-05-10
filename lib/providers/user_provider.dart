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
  User? lastUser;

  @override
  Future<UserModel?> build() async {
    final StreamSubscription<User?> sub = _auth.authStateChanges().listen((
      user,
    ) {
      print('authStateChanges emitted: $user');

      // Only rebuild if user changes
      if (user?.uid != lastUser?.uid) {
        lastUser = user;
        ref.invalidateSelf();
      }
    }); // Provider rebuilds whenever auth state changes

    // Prevent memory leaks
    ref.onDispose(() {
      sub.cancel();
    });

    final user = _auth.currentUser;
    print('User from provider: $user');
    if (user == null) return null;

    final profile = await _userService.getUser(user.uid);
    print('Loaded user profile: $profile');
    return profile;
  }
}
