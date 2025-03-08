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
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.only(top: 20, left: 20, right: 20),
            child: Column(
              children: [
               // This is the image
              SizedBox(
                height: 250,
                child: SvgPicture.asset(
                  'assets/signup.svg',
                  fit: BoxFit.contain,
                )
              ),
              
              Spacer(),
              Column(
                children: [
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
                  ),
                ]
              ),
              Spacer()
            ]
            )
          ),
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
  final GlobalKey<FormState> _formGlobalKey = GlobalKey<FormState>();
  final Color primaryColor = Colors.deepOrange;
  final Color accentColor = Color.fromARGB(106, 255, 204, 188);

  String? isFieldValid(String? value, String type) {
    if (value == null || value.isEmpty) {
      if (type.toLowerCase() == "username") {
        return "Username cannot be empty.";
      } else if (type.toLowerCase() == "password") {
        return "Password cannot be empty.";
      } else if (type.toLowerCase() == "email") {
        return "Email cannot be empty";
      }
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formGlobalKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[

          // Input fields
          TextFormField(
            cursorColor: primaryColor,
            decoration: InputDecoration(
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: primaryColor)
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: primaryColor)
              ),
              filled: true,
              fillColor: accentColor,
              labelText: 'Username',
              labelStyle: TextStyle(
                fontSize: 18,
                color: Colors.grey[700],
                fontFamily: 'Poppins'
              ),
              floatingLabelStyle: TextStyle(
                color: primaryColor,
              )
            ),
            validator: (value) => isFieldValid(value, "username")
          ),
          SizedBox(height: 15),
          TextFormField(
            cursorColor: primaryColor,
            decoration: InputDecoration(
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: primaryColor)
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: primaryColor)
              ),
              filled: true,
              fillColor: accentColor,
              labelText: 'Email',
              labelStyle: TextStyle(
                fontSize: 18,
                color: Colors.grey[700],
                fontFamily: 'Poppins'
              ),
              floatingLabelStyle: TextStyle(
                color: primaryColor,
              )
            ),
            validator: (value) => isFieldValid(value, "email")
          ),
          SizedBox(height: 15),
          TextFormField(
            cursorColor: primaryColor,
            decoration: InputDecoration(
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: primaryColor)
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: primaryColor)
              ),
              filled: true,
              fillColor: accentColor,
              labelText: 'Password',
              labelStyle: TextStyle(
                fontSize: 18,
                color: Colors.grey[700],
                fontFamily: 'Poppins'
              ),
              floatingLabelStyle: TextStyle(
                color: primaryColor,
              )
            ),
            validator: (value) => isFieldValid(value, "password")
          ),
          SizedBox(height: 15),
          TextFormField(
            cursorColor: primaryColor,
            decoration: InputDecoration(
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: primaryColor)
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: primaryColor)
              ),
              filled: true,
              fillColor: accentColor,
              labelText: 'Confirm Password',
              labelStyle: TextStyle(
                fontSize: 18,
                color: Colors.grey[700],
                fontFamily: 'Poppins'
              ),
              floatingLabelStyle: TextStyle(
                color: primaryColor,
              )
            ),
            validator: (value) => isFieldValid(value, "password")
          ),
          SizedBox(height: 10),

          // Button
          FilledButton(
            onPressed: () {
              _formGlobalKey.currentState!.validate();
            },
            style: FilledButton.styleFrom(
              backgroundColor: Colors.deepOrange[400],
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8)
              )
            ),
            child: Text(
              'Next',
              style: TextStyle(
                fontFamily: 'Poppins',
                color: Colors.white
              )
            ),
          )
        ]
      )
    );
  }
}