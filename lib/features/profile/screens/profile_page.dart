import 'package:dishedout/models/user_model.dart';
import 'package:dishedout/services/user_service.dart';
import 'package:dishedout/shared/widgets/avatar.dart';
import 'package:flutter/material.dart';
import 'package:dishedout/services/auth.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final Auth _auth = Auth();
  final UserService _userService = UserService();

  late Future<UserModel?> _userFuture;

  @override
  void initState() {
    super.initState();
    _userFuture = _userService.getUser(_auth.currentUser!.uid);
  }

  void _refreshUser() {
    setState(() {
      _userFuture = _userService.getUser(_auth.currentUser!.uid);
    });
  }

  @override
  Widget build(BuildContext context) {
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
        child: FutureBuilder<UserModel?>(
          future: _userFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (!snapshot.hasData || snapshot.data == null) {
              return const Center(child: Text('User not found.'));
            }

            final user = snapshot.data!;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Avatar
                Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () async {
                      await _userService.uploadImage();
                      _refreshUser();
                    },
                    borderRadius: BorderRadius.circular(100),
                    child: Avatar(user: user, radius: 72, fontSize: 32),
                  ),
                ),
                const SizedBox(height: 20),

                // Display Name or Email
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
            );
          },
        ),
      ),
    );
  }
}
