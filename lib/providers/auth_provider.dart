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
  late StreamSubscription<User?> _authSub;

  @override
  FutureOr<UserModel?> build() async {
    late UserModel? profile;

    // 1. Set up auth listener to track changes in real-time
    _authSub = _auth.authStateChanges.listen((user) async {
      if (user == null) {
        profile = null;
        state = const AsyncData(null);
      } else {
        profile = await _userService.getUser(user.uid);
        state = AsyncData(profile);
      }
    });

    // 2. Clean up memory
    ref.onDispose(() {
      _authSub.cancel();
    });

    // 3. Load and return initial value for build
    final currentUser = _auth.currentUser;
    if (currentUser == null) {
      return null;
    }
    final initialProfile = await _userService.getUser(currentUser.uid);
    return initialProfile;
  }

  /// Log in and set state
  Future<void> login(String email, String password) async {
    state = const AsyncLoading();
    print("Email: $email. Password: $password");

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

  Future<void> signOut() async {
    await _auth.signOut();
    ref.read(isAuthorisedProvider.notifier).set(false);
    state = const AsyncData(null);
  }

  Future<void> changeProfilePic() async {
    final previousState = state;
    state = const AsyncLoading();

    try {
      final currentUser = _auth.currentUser;
      await _userService.uploadImage();
      final updatedProfile = await _userService.getUser(currentUser!.uid);
      state = AsyncData(updatedProfile);
    } catch (e) {
      state = previousState;
      print("ERROR CHANGING PROFILE: $e");
    }
  }

  Future<void> changeProfile(Map<String, dynamic> data) async {
    final previousState = state;
    final user = state.asData?.value;
    final authUser = _auth.currentUser;
    state = const AsyncLoading();

    if (user == null || authUser == null) return;

    final newEmail = data['email'];
    final newDisplayName = data['displayName'];
    // final phone = data['phone'];

    try {
      // 1. Update FirebaseAuth user credentials
      if (authUser.email != newEmail) {
        await authUser.verifyBeforeUpdateEmail(
          newEmail,
        ); // Verification sent to email, then email is updated
      }

      if (authUser.displayName != newDisplayName) {
        await authUser.updateDisplayName(newDisplayName);
      }

      // TODO: Update phone number for authUser
      // if (authUser.phoneNumber != newPhone) {
      //   await authUser.updatePhoneNumber(newPhone);
      // }

      // 2. Update Firestore user document
      await _userService.updateProfile(user.uid, data);

      // 3. Update changes to show in UI
      final updatedProfile = await _userService.getUser(authUser.uid);
      state = AsyncData(updatedProfile);
    } catch (e) {
      state = previousState;
      print("Error changing profile: $e");
      rethrow;
    }
  }
}
