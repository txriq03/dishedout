import 'package:dishedout/features/product/screens/edit_profile_page.dart';
import 'package:dishedout/providers/auth_provider.dart';
import 'package:dishedout/shared/widgets/avatar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProfilePage extends ConsumerStatefulWidget {
  const ProfilePage({super.key});

  @override
  ConsumerState<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends ConsumerState<ProfilePage> {
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
        actions: [
          PopupMenuButton<String>(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            onSelected: (value) async {
              switch (value) {
                case 'edit profile':
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const EditProfilePage(),
                    ),
                  );
                  break;
                case 'logout':
                  await ref.read(authNotifierProvider.notifier).signOut();
                  break;
              }
            },
            itemBuilder: (BuildContext context) {
              return [
                PopupMenuItem(
                  value: 'edit profile',
                  child: Row(
                    children: [
                      Icon(
                        Icons.settings,
                        size: 20,
                        color: Colors.deepOrange.shade300,
                      ),
                      SizedBox(width: 5),
                      Text('Edit Profile'),
                    ],
                  ),
                ),
                PopupMenuItem(
                  value: 'logout',
                  child: Row(
                    children: [
                      Icon(
                        Icons.logout_rounded,
                        size: 20,
                        color: Colors.deepOrange.shade300,
                      ),
                      SizedBox(width: 5),
                      Text('Logout'),
                    ],
                  ),
                ),
              ];
            },
          ),
        ],
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
                      await ref
                          .read(authNotifierProvider.notifier)
                          .changeProfilePic();
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
