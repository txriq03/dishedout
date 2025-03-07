import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  final String name = "Tariq Mullings";
  final int age = 22;
  final bool isPremium = false;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      debugShowMaterialGrid: false,
      home: Scaffold(
        backgroundColor: Colors.black,
        body: Center(
          child: Container(
            margin: EdgeInsetsDirectional.only(top: 150),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(topLeft: Radius.circular(45), topRight: Radius.circular(45)),
            ),
          ),
        ),
      ),
    );
  }
}