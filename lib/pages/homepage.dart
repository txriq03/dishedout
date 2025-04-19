import 'dart:math';
import 'package:dishedout/pages/search_bar.dart';
import 'package:dishedout/pages/user_uploads.dart';
import 'package:flutter/material.dart';
import 'package:dishedout/auth.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});
  final Auth _auth = Auth();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(80),
        child: AppBar(
          automaticallyImplyLeading: false, // Removes back button
          title: Padding(
            padding: EdgeInsets.only(top: 12.0),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 21,
                  backgroundColor:
                      ([
                        Colors.deepOrange,
                        Colors.blue,
                        Colors.green,
                        Colors.purple,
                        Colors.teal,
                      ]..shuffle(Random())).first,
                  child: Text(
                    (_auth.currentUser?.displayName != null &&
                            _auth.currentUser!.displayName!.isNotEmpty)
                        ? _auth.currentUser!.displayName![0].toUpperCase()
                        : (_auth.currentUser?.email?[0].toUpperCase() ?? 'U'),
                    style: const TextStyle(fontSize: 21, color: Colors.white),
                  ),
                ),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Welcome back",
                      style: TextStyle(
                        color: Colors.grey[700],
                        fontSize: 18,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                    Text(
                      _auth.currentUser?.displayName ??
                          _auth.currentUser?.email ??
                          'User',
                      style: TextStyle(
                        color: Colors.grey[200],
                        fontSize: 21,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          actions: [
            IconButton(
              icon: const Icon(Icons.logout_rounded),
              color: Colors.deepOrange,
              tooltip: 'Logout',
              onPressed: () async {
                await _auth.signOut();
              },
            ),
          ],
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          children: [SearchWidget(), SizedBox(height: 20), UserUploads()],
        ),
      ),
    );
  }
}
