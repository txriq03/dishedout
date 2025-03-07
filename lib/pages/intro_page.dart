import 'package:flutter/material.dart';


class IntroPage extends StatelessWidget {
  const IntroPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.black,
        body: Column(
          children: [

            // This is the image
            Container(
              height: 500,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/meat.jpg'),
                  fit: BoxFit.cover,
                )
              )
            ),

            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Welcome to",
                    style: TextStyle(
                      fontSize: 21,
                      fontFamily: "Poppins",
                      color: Colors.grey[700],
                    )
                  ),
                  Text(
                    "DishedOut",
                    style: TextStyle(
                      fontSize: 55,
                      fontFamily: "Poppins",
                      fontWeight: FontWeight.bold,
                      color: Colors.deepOrange[400]
                    )
                  )
                ]
              ),
            )
          ],
        )
      )
    );
  }
}