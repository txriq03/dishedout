import 'package:flutter/material.dart';

class AddFoodPage extends StatelessWidget {
  const AddFoodPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 19, 19, 19),
      appBar: AppBar(
        title: const Text('Add Food'),
        backgroundColor: const Color.fromARGB(255, 19, 19, 19),
        centerTitle: true,
        elevation: 0,
      ),
      body: const Center(
        child: Text(
          'addFood',
          style: TextStyle(fontSize: 20, color: Colors.white),
        ),
      ),
    );
  }
}
