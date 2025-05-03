import 'package:dishedout/shared/widgets/avatar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dishedout/features/authentication/providers/user_provider.dart';
import 'package:dishedout/services/auth.dart';

class ProfilePage extends ConsumerWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUser = ref.watch(currentUserProvider);
    final auth = Auth();

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
        child:
            currentUser == null
                ? const Center(child: CircularProgressIndicator())
                : Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Avatar
                    Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () async {
                          // Refresh user after uploading new avatar
                          await ref
                              .read(currentUserProvider.notifier)
                              .uploadImageAndReload();
                        },
                        borderRadius: BorderRadius.circular(100),
                        child: Avatar(
                          user: currentUser,
                          radius: 72,
                          fontSize: 32,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Display Name or Email
                    Text(
                      currentUser.displayName,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                      ),
                    ),

                    const SizedBox(height: 10),
                    Text(
                      currentUser.email,
                      style: TextStyle(fontSize: 14, color: Colors.grey[500]),
                    ),

                    const SizedBox(height: 40),

                    // Logout Button
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
                          await auth.signOut();
                        },
                        icon: const Icon(Icons.logout, color: Colors.white),
                        label: const Text(
                          "Log out",
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                      ),
                    ),
                  ],
                ),
      ),
    );
  }
}
