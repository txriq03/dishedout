import 'package:dishedout/features/authentication/presentation/screens/login_page.dart';
import 'package:dishedout/features/authentication/presentation/screens/signup_page.dart';
import 'package:flutter/material.dart';

class AuthPage extends StatelessWidget {
  const AuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    print('Authpage is being displayed');
    return Scaffold(
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
              ),
            ),
          ),

          Spacer(),
          // Rest of the elements below image
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.only(top: 10, left: 25, right: 25),
              child: Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Text elements
                    Text(
                      "Welcome to",
                      style: TextStyle(
                        fontSize: 21,
                        fontFamily: "Poppins",
                        color: const Color.fromARGB(66, 255, 255, 255),
                      ),
                    ),
                    Text(
                      "DishedOut",
                      style: TextStyle(
                        fontSize: 55,
                        fontFamily: "Poppins",
                        fontWeight: FontWeight.bold,
                        color: Colors.deepOrange[500],
                      ),
                    ),
                    Text(
                      "Share your meals with the community and earn some cash while doing it!",
                      style: TextStyle(
                        fontSize: 16,
                        fontFamily: "Poppins",
                        color: Colors.grey[400],
                      ),
                    ),
                    SizedBox(height: 20),

                    // Login and Signup buttons
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              // Navigate to login
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => const Login(),
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              padding: EdgeInsets.symmetric(vertical: 15),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: Text(
                              "Login",
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 20),
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () {
                              // Navigate to Sign up
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => const Signup(),
                                ),
                              );
                            },
                            style: OutlinedButton.styleFrom(
                              side: BorderSide(color: Colors.white),
                              padding: EdgeInsets.symmetric(vertical: 15),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: Text(
                              "Signup",
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          Spacer(),
        ],
      ),
    );
  }
}
