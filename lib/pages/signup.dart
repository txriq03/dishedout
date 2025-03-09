import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class Signup extends StatelessWidget {
  const Signup({ super.key });

  @override
  Widget build(BuildContext context){
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.grey[900],
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                  height: 70,
                  child: Stack(
                    children: [
                      Positioned(
                        top: 10, 
                        left: 16,
                        child: BackButton(
                          color: Colors.white,
                          onPressed: () {
                            Navigator.pop(context);
                          }
                        )
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsetsDirectional.symmetric(vertical: 50, horizontal: 25),
                  child: Column(
                    children: [
                      Text(
                        "DishedOut",
                        style: TextStyle(
                          fontFamily: "Poppins",
                          fontSize: 52,
                          color: Colors.deepOrange[400],
                          fontWeight: FontWeight.bold
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        "Create your account",
                        style: TextStyle(
                          fontSize: 24,
                          color: Colors.grey[300]
                        ),
                      ),
                      SizedBox(height: 20),
                      SignupForm()


                    ],
                  )
                )
                    
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
  final Color accentColor = Colors.deepOrange[400] as Color;
  final Color primaryColor = Color.fromARGB(106, 255, 204, 188);
  final Color backgroundFieldColor = Color.fromARGB(255, 49, 49, 49);

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
            cursorColor: Colors.deepOrange,
            style: TextStyle(color: Colors.white),
            decoration: InputDecoration(
              prefixIcon: Icon(
                Icons.account_circle,
                color: Colors.grey[700],
                semanticLabel: 'Input display name here',
              ),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.transparent),
                borderRadius: BorderRadius.circular(12)
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.transparent),
                borderRadius: BorderRadius.circular(12)
              ),
              errorBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.transparent),
                borderRadius: BorderRadius.circular(12)
              ),
              focusedErrorBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.transparent),
                borderRadius: BorderRadius.circular(12)
              ),
              filled: true,
              fillColor: backgroundFieldColor,
              labelText: 'Display name',
              labelStyle: TextStyle(
                color: Colors.grey[600],
                fontFamily: 'Poppins'
              ),
            ),
            validator: (value) => isFieldValid(value, "username")
          ),
          SizedBox(height: 15),
          TextFormField(
            style: TextStyle(color: Colors.white),
            cursorColor: Colors.deepOrange,
            decoration: InputDecoration(
              prefixIcon: Icon(
                Icons.alternate_email_rounded,
                color: Colors.grey[700],
                semanticLabel: 'Input email here',
              ),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.transparent),
                borderRadius: BorderRadius.circular(12)
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.transparent),
                borderRadius: BorderRadius.circular(12)
              ),
              errorBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.transparent),
                borderRadius: BorderRadius.circular(12)
              ),
              focusedErrorBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.transparent),
                borderRadius: BorderRadius.circular(12)
              ),
             
              filled: true,
              fillColor: backgroundFieldColor,
              labelText: 'Email',
              labelStyle: TextStyle(
                color: Colors.grey[600],
                fontFamily: 'Poppins'
              ),
            ),
            validator: (value) => isFieldValid(value, "email")
          ),
          SizedBox(height: 15),
          TextFormField(
            style: TextStyle(color: Colors.white),
            cursorColor: Colors.deepOrange,
            decoration: InputDecoration(
              prefixIcon: Icon(
                Icons.lock_rounded,
                color: Colors.grey[700],
                semanticLabel: 'Input password',
              ),
              suffixIcon: Icon(
                Icons.visibility_off_rounded,
                color: Colors.grey[500],
              ),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.transparent),
                borderRadius: BorderRadius.circular(12)
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.transparent),
                borderRadius: BorderRadius.circular(12)
              ),
              errorBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.transparent),
                borderRadius: BorderRadius.circular(12)
              ),
              focusedErrorBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.transparent),
                borderRadius: BorderRadius.circular(12)
              ),
              filled: true,
              fillColor: backgroundFieldColor,
              labelText: 'Password',
              labelStyle: TextStyle(
                color: Colors.grey[600],
                fontFamily: 'Poppins'
              )
            ),
            obscureText: true,
            validator: (value) => isFieldValid(value, "password")
          ),
          SizedBox(height: 15),
          TextFormField(
            style: TextStyle(color: Colors.white),
            cursorColor: Colors.deepOrange,
            decoration: InputDecoration(
              prefixIcon: Icon(
                Icons.lock_rounded,
                color: Colors.grey[700],
                semanticLabel: 'Confirm your password',
              ),
              suffixIcon: Icon(
                Icons.visibility_off_rounded,
                color: Colors.grey[500],
              ),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.transparent),
                borderRadius: BorderRadius.circular(12)
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.transparent),
                borderRadius: BorderRadius.circular(12)
              ),
              errorBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.transparent),
                borderRadius: BorderRadius.circular(12)
              ),
              focusedErrorBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.transparent),
                borderRadius: BorderRadius.circular(12)
              ),
              filled: true,
              fillColor: backgroundFieldColor,
              labelText: 'Confirm Password',
              labelStyle: TextStyle(
                color: Colors.grey[600],
                fontFamily: 'Poppins'
              )
            ),
            obscureText: true,
            validator: (value) => isFieldValid(value, "password")
          ),
          
          SizedBox(height: 35),
          
          
          // Sign up button
          Container(
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.deepOrange.withValues(alpha: 0.5),
                  blurRadius: 15,
                  spreadRadius: 0.1,
                )
              ],
              borderRadius: BorderRadius.circular(25)
            ),
            child: FilledButton(
              onPressed: () {
                _formGlobalKey.currentState!.validate();
              },
              style: FilledButton.styleFrom(
                minimumSize: Size(double.infinity, 55),
                backgroundColor: Colors.deepOrange[400],
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25)
                )
              ),
              child: Text("Sign up", style: TextStyle(fontSize: 18))
            ),
          ),
          
          // Divider
          Row(
            children: [
              Expanded(child: Divider(
                color: Colors.grey[700],
                thickness: 2,
                
              )),
              Padding(
                padding: EdgeInsetsDirectional.symmetric(horizontal: 10, vertical: 35),
                child: Text(
                  "Or continue with",
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 16,
                    color: Colors.white
                  ),
                ),
              ),
              Expanded(child: Divider(
                color: Colors.grey[700],
                thickness: 2,
              ))
            ]
          ),

          // Google button
          OutlinedButton(
            onPressed: () {

            },
            style: OutlinedButton.styleFrom(
              backgroundColor: Colors.transparent,
              minimumSize: Size(double.infinity, 55),
              shape: RoundedRectangleBorder(
                side: BorderSide(color: accentColor, width: 2),
                borderRadius: BorderRadius.circular(15)
              )
            ),
            child: Text(
              'Continue with Google',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 16,
                color: Colors.white
              ),
            )
          )
        ]
      )
    );
  }
}