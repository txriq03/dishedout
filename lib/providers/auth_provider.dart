import 'dart:async';

import 'package:dishedout/models/user_model.dart';
import 'package:dishedout/services/auth_service.dart';
import 'package:dishedout/services/user_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'auth_provider.g.dart';

@riverpod
class AuthNotifier extends _$AuthNotifier {
  final AuthService _auth = AuthService();
  final UserService _userService = UserService();
  User? lastUser;

  @override
  Future<UserModel?> build() async {
    final StreamSubscription<User?> sub = _auth.authStateChanges.listen((user) {
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

  Future<void> login(String email, String password) async {
    try {
      await _auth.login(email: email, password: password);
    } catch (e) {
      print("Error during login: $e");
    }
  }

  Future<void> signUp(String displayName, String email, String password) async {
    try {
      final UserCredential credential = await _auth.signUp(
        email: email,
        password: password,
      );

      credential.user!.updateDisplayName(displayName);

      // Refresh user to get updated display name
      await credential.user!.reload();
      final updatedUser = _auth.currentUser;

      // Add user to Firestore
      await _userService.addUserToFirestore(updatedUser!);
    } catch (e) {
      print('Error during sign up: $e');
    }

    Future<void> signOut() async {
      await _auth.signOut();
    }
  }
}
