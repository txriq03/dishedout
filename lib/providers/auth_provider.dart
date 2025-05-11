import 'dart:async';

import 'package:dishedout/models/user_model.dart';
import 'package:dishedout/services/auth_service.dart';
import 'package:dishedout/services/user_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'auth_gate_provider.dart';
part 'auth_provider.g.dart';

@riverpod
class AuthNotifier extends _$AuthNotifier {
  final _auth = AuthService();
  final _userService = UserService();

  @override
  Future<UserModel?> build() async {
    final user = _auth.currentUser;
    if (user == null) {
      ref.read(isAuthorisedProvider.notifier).set(false);
      return null;
    }

    ref.read(isAuthorisedProvider.notifier).set(true);
    return await _userService.getUser(user.uid);
  }

  /// Log in and set state
  Future<void> login(String email, String password) async {
    state = const AsyncLoading();
    print("Email: $email. Password: $password");

    // OLD CODE
    // state = await AsyncValue.guard(() async {
    //   await _auth.login(email: email, password: password);
    //   final currentUser = _auth.currentUser!;
    //   ref.read(isAuthorisedProvider.notifier).set(true);
    //   return await _userService.getUser(currentUser.uid);
    // });

    try {
      await _auth.login(email: email, password: password);
      final currentUser = _auth.currentUser!;
      ref.read(isAuthorisedProvider.notifier).set(true);
      final profile = await _userService.getUser(currentUser.uid);

      state = AsyncData(profile);
    } on FirebaseAuthException catch (e, st) {
      state = AsyncError(e, st);
      rethrow; // handle error on frontend
    }
  }

  /// Sign up and set state
  Future<void> signUp(String displayName, String email, String password) async {
    state = const AsyncLoading();
    print("Email: $email. Password: $password");
    state = await AsyncValue.guard(() async {
      final UserCredential credential = await _auth.signUp(
        email: email,
        password: password,
      );

      await credential.user!.updateDisplayName(displayName);
      await credential.user!.reload();
      final updatedUser = _auth.currentUser!;

      await _userService.addUserToFirestore(updatedUser);
      ref.read(isAuthorisedProvider.notifier).set(true);

      return await _userService.getUser(updatedUser.uid);
    });

    try {
      final UserCredential credential = await _auth.signUp(
        email: email,
        password: password,
      );
      await credential.user!.updateDisplayName(displayName);
      await credential.user!.reload();
      final updatedUser = _auth.currentUser!;

      await _userService.addUserToFirestore(updatedUser);
      ref.read(isAuthorisedProvider.notifier).set(true);

      final profile = await _userService.getUser(updatedUser.uid);

      state = AsyncData(profile);
    } on FirebaseAuthException catch (e, st) {
      state = AsyncError(e, st);
      rethrow; // handle error on frontend
    }
  }

  /// Sign out and clear state
  Future<void> signOut() async {
    await _auth.signOut();
    ref.read(isAuthorisedProvider.notifier).set(false);
    state = const AsyncData(null);
  }
}
