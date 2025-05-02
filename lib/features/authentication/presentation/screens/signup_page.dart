import 'package:dishedout/features/authentication/presentation/widgets/signup_form.dart';
import 'package:flutter/material.dart';

class Signup extends StatelessWidget {
  const Signup({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 20, 20, 20),
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
                        style: ButtonStyle(
                          backgroundColor: WidgetStateProperty.all(
                            Colors.transparent,
                          ),
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsetsDirectional.symmetric(
                  vertical: 25,
                  horizontal: 25,
                ),
                child: Column(
                  children: [
                    Text(
                      "DishedOut",
                      style: TextStyle(
                        fontFamily: "Poppins",
                        fontSize: 52,
                        color: Colors.deepOrange[400],
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 2),
                    Text(
                      "Create your account",
                      style: TextStyle(
                        fontSize: 28,
                        color: Colors.grey[300],
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 35),
                    SignupForm(),
                    SizedBox(height: 25),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Already have an account?",
                          style: TextStyle(color: Colors.grey[400]),
                        ),
                        SizedBox(width: 5),
                        Text(
                          "Sign in",
                          style: TextStyle(color: Colors.deepOrange[400]),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
