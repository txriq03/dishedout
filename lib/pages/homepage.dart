import 'package:flutter/material.dart';
import 'package:dishedout/auth.dart';

class HomePage extends StatelessWidget {
  final Auth _auth = Auth(); // Reference to your custom Auth class

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Welcome Home"),
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
      body: const Center(
        child: Text('You are now logged in!', style: TextStyle(fontSize: 18)),
      ),
    );
  }
}
