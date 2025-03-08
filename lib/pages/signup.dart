import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class Signup extends StatelessWidget {
  const Signup({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context){
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.white,
        body: Padding(
          padding: EdgeInsets.only(top: 50, left: 20, right: 20),
          child: Column(
            children: [
             // This is the image
            Container(
              height: 400,
              child: SvgPicture.asset(
                'assets/signup.svg',
                fit: BoxFit.fitWidth,
              )
            ),

            Text(
              "Sign up",
              style: TextStyle(
                fontSize: 32,
                fontFamily: "Poppins",
                fontWeight: FontWeight.bold
              )
            ),
            Text(
              "Let's first get your name!",
              style: TextStyle(
                fontFamily: "Poppins",
                fontSize: 21,
                color: Colors.grey[500]
              )
            )
          ]
          )
        )
      )
    );
  }
}