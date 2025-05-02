import 'package:dishedout/services/user_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:dishedout/models/user_model.dart';

class UserNotifier extends StateNotifier<UserModel?> {
  UserNotifier()
    : super(null); // This is necessary when extending the class StateNotifier

  final UserService _userService = UserService();

  // Load user from firestore
  Future<void> loadUser() async {
    final UserService userService = UserService();
    final User? currentUser = FirebaseAuth.instance.currentUser;

    if (currentUser == null) {
      state = null;
      return;
    }

    final UserModel? user = await userService.getUser(currentUser.uid);

    if (user == null) {
      state = null;
      return;
    }

    state = user;
  }

  // Clear user
  void clearUser() {
    state = null;
  }

  // Update user manually
  void updateuser(UserModel user) {
    state = user;
  }

  // Update state when changing profile picture
  Future<void> uploadImageAndReload() async {
    await _userService.uploadImage();
    await loadUser(); // refresh after upload
  }
}

final currentUserProvider = StateNotifierProvider<UserNotifier, UserModel?>((
  ref,
) {
  return UserNotifier();
});
