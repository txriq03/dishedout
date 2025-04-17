import 'package:flutter/material.dart';
import 'package:dishedout/auth.dart';

class HomePage extends StatelessWidget {
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
                  "Username",
                  style: TextStyle(
                    color: Colors.grey[200],
                    fontSize: 21,
                    fontWeight: FontWeight.w300,
                  ),
                ),
              ],
            ),
          ),

          backgroundColor: Colors.grey[900],
          actions: [
            IconButton(
              icon: const Icon(Icons.logout),
              tooltip: 'Logout',
              onPressed: () async {
                await _auth.signOut();
              },
            ),
          ],
        ),
      ),
    );
  }
}
