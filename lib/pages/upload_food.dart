import 'package:flutter/material.dart';

class UploadFoodPage extends StatelessWidget {
  const UploadFoodPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 19, 19, 19),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20),
          child: Column(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: SizedBox(
                  height: 15,
                  child: LinearProgressIndicator(
                    value: 0.2,
                    backgroundColor: Colors.grey[900],
                    color: Colors.deepOrange,
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
