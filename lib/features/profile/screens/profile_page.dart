import 'package:dishedout/providers/auth_provider.dart';
import 'package:dishedout/services/user_service.dart';
import 'package:dishedout/shared/widgets/avatar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProfilePage extends ConsumerStatefulWidget {
  const ProfilePage({super.key});

  @override
  ConsumerState<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends ConsumerState<ProfilePage> {
  final UserService _userService = UserService();

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authNotifierProvider);
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 0,
        title: const Text(
          'Profile',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w300),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: authState.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, _) => Center(child: Text('Error $e')),
          data: (user) {
            if (user == null) {
              return const Center(child: Text('User not found.'));
            }
            return Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () async {
                      await _userService.uploadImage();
                      // TODO: Refresh the user after uploading image
                    },
                    borderRadius: BorderRadius.circular(100),
                    child: Avatar(user: user, radius: 72, fontSize: 32),
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  user.displayName,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  user.email,
                  style: TextStyle(fontSize: 14, color: Colors.grey[500]),
                ),
                const SizedBox(height: 40),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () async {
                      await ref.read(authNotifierProvider.notifier).signOut();
                    },
                    icon: const Icon(Icons.logout, color: Colors.white),
                    label: const Text(
                      "Log out",
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
        // child: FutureBuilder<UserModel?>(
        //   future: _userFuture,
        //   builder: (context, snapshot) {
        //     if (snapshot.connectionState == ConnectionState.waiting) {
        //       return const Center(child: CircularProgressIndicator());
        //     }

        //     if (!snapshot.hasData || snapshot.data == null) {
        //       return const Center(child: Text('User not found.'));
        //     }

        //     final user = snapshot.data!;

        //     return Column(
        //       crossAxisAlignment: CrossAxisAlignment.center,
        //       children: [
        //         // Avatar
        //         Material(
        //           color: Colors.transparent,
        //           child: InkWell(
        //             onTap: () async {
        //               await _userService.uploadImage();
        //               _refreshUser();
        //             },
        //             borderRadius: BorderRadius.circular(100),
        //             child: Avatar(user: user, radius: 72, fontSize: 32),
        //           ),
        //         ),
        //         const SizedBox(height: 20),

        //         // Display Name or Email
        //         Text(
        //           user.displayName,
        //           style: const TextStyle(
        //             fontSize: 20,
        //             fontWeight: FontWeight.w500,
        //           ),
        //         ),

        //         const SizedBox(height: 10),
        //         Text(
        //           user.email,
        //           style: TextStyle(fontSize: 14, color: Colors.grey[500]),
        //         ),

        //         const SizedBox(height: 40),

        //         // Logout Button
        //         SizedBox(
        //           width: double.infinity,
        //           child: ElevatedButton.icon(
        //             style: ElevatedButton.styleFrom(
        //               padding: const EdgeInsets.symmetric(vertical: 14),
        //               shape: RoundedRectangleBorder(
        //                 borderRadius: BorderRadius.circular(12),
        //               ),
        //             ),
        //             onPressed: () async {
        //               await ref.read(authNotifierProvider.notifier).signOut();
        //             },
        //             icon: const Icon(Icons.logout, color: Colors.white),
        //             label: const Text(
        //               "Log out",
        //               style: TextStyle(color: Colors.white, fontSize: 16),
        //             ),
        //           ),
        //         ),
        //       ],
        //     );
        //   },
        // ),
      ),
    );
  }
}
