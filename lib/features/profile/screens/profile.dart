import 'package:flutter/material.dart';
import 'package:dishedout/services/auth.dart';

class ProfilePage extends StatelessWidget {
  final Auth _auth = Auth();

  @override
  Widget build(BuildContext context) {
    final user = _auth.currentUser;

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: const Text(
          'Profile',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Avatar
            CircleAvatar(
              radius: 40,
              backgroundColor: Colors.deepOrange,
              child: Text(
                (user?.displayName != null && user!.displayName!.isNotEmpty)
                    ? user.displayName![0].toUpperCase()
                    : (user?.email?[0].toUpperCase() ?? 'U'),
                style: const TextStyle(fontSize: 32, color: Colors.white),
              ),
            ),
            const SizedBox(height: 20),

            // Display Name or Email
            Text(
              user?.displayName ?? user?.email ?? 'Unknown User',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
            ),

            const SizedBox(height: 10),
            Text(
              user?.email ?? '',
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
                  await _auth.signOut();
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
