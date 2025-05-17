import 'package:dishedout/features/authentication/screens/login_page.dart';
import 'package:dishedout/features/authentication/screens/signup_page.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class AuthPage extends StatelessWidget {
  const AuthPage({super.key});

  @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        clipBehavior: Clip.none, // Allow overflow
        children: [
          // Lottie Animation Overflowing at the Top
          Positioned(
            top: -75, // Adjust this value to move it further up
            left: 0,
            right: 0,
            child: Lottie.asset(
              'assets/animations/abstract.json',
              height: 300,
              fit: BoxFit.cover,
            ),
          ),

          // Main content
          SafeArea(
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Welcome to ', style: TextStyle(fontSize: 21)),
                      Text(
                        'DishedOut',
                        style: TextStyle(
                          fontSize: 21,
                          color: Theme.of(context).colorScheme.primary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  Text(
                    "Contribute to your community and reduce household waste. Don't bin it, share it!",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white.withAlpha(150)),
                  ),
                  SizedBox(height: 30),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 50),
                    child: Column(
                      children: [
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            minimumSize: const Size.fromHeight(55),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => const Login(),
                              ),
                            );
                          },
                          child: Text('Login', style: TextStyle(fontSize: 18)),
                        ),
                        SizedBox(height: 10),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            minimumSize: const Size.fromHeight(55),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => const Signup(),
                              ),
                            );
                          },
                          child: Text(
                            'Sign up',
                            style: TextStyle(fontSize: 18),
                          ),
                        ),
                        SizedBox(height: 20),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
