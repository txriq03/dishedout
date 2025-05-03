import 'dart:async';

import 'package:dishedout/models/user_model.dart';
import 'package:dishedout/services/user_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UserNotifier extends AsyncNotifier<UserModel?> {
  @override
  FutureOr<UserModel?> build() async {
    final currentUser = FirebaseAuth.instance.currentUser;

    if (currentUser == null) {
      return null;
    }

    final user = await UserService().getUser(currentUser.uid);
    return user;
  }

  Future<void> refreshUser() async {
    state = const AsyncValue.loading();
    state = AsyncValue.data(await build());
  }

  void clearUser() {
    state = const AsyncValue.data(null);
  }

  Future<void> uploadImageAndReload() async {
    // Upload image
    await UserService().uploadImage();

    // Refresh user
    state = const AsyncValue.loading();
    state = AsyncValue.data(await build());
  }
}

final currentUserProvider = AsyncNotifierProvider<UserNotifier, UserModel?>(
  UserNotifier.new,
);
