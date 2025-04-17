import 'package:flutter/material.dart';
import 'package:dishedout/auth.dart';

class HomePage extends StatelessWidget {
  final Auth _auth = Auth();
  final Color backgroundColor = Color.fromARGB(255, 19, 19, 19);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(80),
        child: AppBar(
          automaticallyImplyLeading: false, // Removes back button
          title: Padding(
            padding: EdgeInsets.only(top: 12.0),
            child: Column(
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
          ),

          backgroundColor: backgroundColor,
          actions: [
            IconButton(
              icon: const Icon(Icons.logout),
              color: Colors.grey[500],
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
          children: [
            TextField(
              style: TextStyle(color: Colors.grey[400]),
              cursorColor: Colors.deepOrange,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.grey[900],
                hintText: 'Search...',
                hintStyle: TextStyle(color: Colors.grey[700]),
                prefixIcon: const Icon(Icons.search, color: Colors.grey),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
