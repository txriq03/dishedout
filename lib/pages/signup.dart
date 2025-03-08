import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class Signup extends StatelessWidget {
  const Signup({ super.key });

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
            SizedBox(
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
              "Let's get your information!",
              style: TextStyle(
                fontFamily: "Poppins",
                fontSize: 21,
                color: Colors.grey[500]
              )
            ),

            Padding(
              padding: EdgeInsets.only(top: 20),
              child: SignupForm()
            )

          ]
          )
        )
      )
    );
  }
}

class SignupForm extends StatefulWidget {
  const SignupForm({ super.key });

  @override
  State<SignupForm> createState() => _SignupFormState();
}

class _SignupFormState extends State<SignupForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          TextFormField(
            cursorColor: Colors.deepOrange[200],
            decoration: InputDecoration(
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Color.fromARGB(255, 255, 60, 0)),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.deepOrange)
              ),
              filled: true,
              fillColor: const Color.fromARGB(106, 255, 204, 188),
              labelText: 'Enter your email',
            )
          ),
          SizedBox(height: 15),
          TextFormField(
            cursorColor: Colors.deepOrange[200],
            decoration: InputDecoration(
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.deepOrange),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.deepOrange)
              ),
              filled: true,
              fillColor: const Color.fromARGB(106, 255, 204, 188),
              labelText: 'Password',
            )
          ),
          SizedBox(height: 15),
          TextFormField(
            cursorColor: Colors.deepOrange[200],
            decoration: InputDecoration(
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.deepOrange),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.deepOrange)
              ),
              filled: true,
              fillColor: const Color.fromARGB(106, 255, 204, 188),
              labelText: 'Confirm Password',
            )
          )
        ]
      )
    );
  }
}