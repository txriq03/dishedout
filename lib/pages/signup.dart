import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:dishedout/auth.dart';
import 'package:dishedout/pages/homepage.dart';

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

class SignupForm extends StatefulWidget {
  const SignupForm({super.key});

  @override
  State<SignupForm> createState() => _SignupFormState();
}

class _SignupFormState extends State<SignupForm> {
  final auth = Auth();
  final GlobalKey<FormState> _formGlobalKey = GlobalKey<FormState>();
  final Color accentColor = Colors.deepOrange[400] as Color;
  final Color primaryColor = Color.fromARGB(106, 255, 204, 188);
  final Color backgroundFieldColor = Colors.grey[900] as Color;

  bool _isPasswordHidden = true;
  bool _isConfirmPasswordHidden = true;

  late TextEditingController _usernameController;
  late TextEditingController _emailController;
  late TextEditingController _passwordController;
  late TextEditingController _confirmPasswordController;
  bool _showUsernameClearButton = false;
  bool _showEmailClearButton = false;

  @override
  void initState() {
    super.initState();
    _usernameController = TextEditingController();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    _confirmPasswordController = TextEditingController();

    _emailController.addListener(() {
      setState(() {
        _showEmailClearButton = _emailController.text.isNotEmpty;
      });
    });

    _usernameController.addListener(() {
      setState(() {
        _showUsernameClearButton = _usernameController.text.isNotEmpty;
      });
    });
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

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
          // Username field
          TextFormField(
            controller: _usernameController,
            cursorColor: Colors.deepOrange,
            style: TextStyle(color: Colors.white),
            decoration: InputDecoration(
              contentPadding: EdgeInsets.symmetric(vertical: 8),
              prefixIcon: Icon(
                Icons.account_circle,
                color: Colors.grey[600],
                semanticLabel: 'Input display name here',
              ),
              suffixIcon:
                  _showUsernameClearButton
                      ? IconButton(
                        icon: Icon(Icons.clear, color: Colors.grey[500]),
                        onPressed: () {
                          _usernameController.clear();
                          setState(() {
                            _showUsernameClearButton = false;
                          });
                        },
                      )
                      : null,
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.transparent),
                borderRadius: BorderRadius.circular(15),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.transparent),
                borderRadius: BorderRadius.circular(15),
              ),
              errorBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.transparent),
                borderRadius: BorderRadius.circular(15),
              ),
              focusedErrorBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.transparent),
                borderRadius: BorderRadius.circular(15),
              ),
              filled: true,
              fillColor: backgroundFieldColor,
              labelText: 'Display name',
              labelStyle: TextStyle(
                color: Colors.grey[600],
                fontFamily: 'Poppins',
                fontSize: 14,
              ),
            ),
            validator: (value) => isFieldValid(value, "username"),
          ),
          SizedBox(height: 15),

          // Email field
          TextFormField(
            controller: _emailController,
            style: TextStyle(color: Colors.white),
            cursorColor: Colors.deepOrange,
            decoration: InputDecoration(
              contentPadding: EdgeInsets.symmetric(vertical: 8),
              prefixIcon: Icon(
                Icons.alternate_email_rounded,
                color: Colors.grey[600],
                semanticLabel: 'Input email here',
              ),
              suffixIcon:
                  _showEmailClearButton
                      ? IconButton(
                        icon: Icon(Icons.clear, color: Colors.grey[500]),
                        onPressed: () {
                          _emailController.clear();
                          setState(() {
                            _showEmailClearButton = false;
                          });
                        },
                      )
                      : null,
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.transparent),
                borderRadius: BorderRadius.circular(15),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.transparent),
                borderRadius: BorderRadius.circular(15),
              ),
              errorBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.transparent),
                borderRadius: BorderRadius.circular(15),
              ),
              focusedErrorBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.transparent),
                borderRadius: BorderRadius.circular(15),
              ),

              filled: true,
              fillColor: backgroundFieldColor,
              labelText: 'Email',
              labelStyle: TextStyle(
                color: Colors.grey[600],
                fontFamily: 'Poppins',
                fontSize: 14,
              ),
            ),
            validator: (value) => isFieldValid(value, "email"),
          ),
          SizedBox(height: 15),

          // Password field
          TextFormField(
            controller: _passwordController,
            style: TextStyle(color: Colors.white),
            cursorColor: Colors.deepOrange,
            decoration: InputDecoration(
              contentPadding: EdgeInsets.symmetric(vertical: 8),
              prefixIcon: Icon(
                Icons.lock_rounded,
                color: Colors.grey[600],
                semanticLabel: 'Input password',
              ),
              suffixIcon: IconButton(
                icon: Icon(
                  _isPasswordHidden
                      ? Icons.visibility_off_rounded
                      : Icons.visibility_rounded,
                  color: Colors.grey[500],
                ),
                onPressed: () {
                  setState(() {
                    _isPasswordHidden = !_isPasswordHidden;
                  });
                },
              ),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.transparent),
                borderRadius: BorderRadius.circular(15),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.transparent),
                borderRadius: BorderRadius.circular(15),
              ),
              errorBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.transparent),
                borderRadius: BorderRadius.circular(15),
              ),
              focusedErrorBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.transparent),
                borderRadius: BorderRadius.circular(15),
              ),
              filled: true,
              fillColor: backgroundFieldColor,
              labelText: 'Password',
              labelStyle: TextStyle(
                color: Colors.grey[600],
                fontFamily: 'Poppins',
                fontSize: 14,
              ),
            ),
            obscureText: _isPasswordHidden,
            validator: (value) => isFieldValid(value, "password"),
          ),
          SizedBox(height: 15),

          // Confirm password field
          TextFormField(
            controller: _confirmPasswordController,
            style: TextStyle(color: Colors.white),
            cursorColor: Colors.deepOrange,
            decoration: InputDecoration(
              contentPadding: EdgeInsets.symmetric(vertical: 8),
              prefixIcon: Icon(
                Icons.lock_rounded,
                color: Colors.grey[600],
                semanticLabel: 'Confirm your password',
              ),
              suffixIcon: IconButton(
                icon: Icon(
                  _isConfirmPasswordHidden
                      ? Icons.visibility_off_rounded
                      : Icons.visibility_rounded,
                  color: Colors.grey[500],
                ),
                onPressed: () {
                  setState(() {
                    _isConfirmPasswordHidden = !_isConfirmPasswordHidden;
                  });
                },
              ),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.transparent),
                borderRadius: BorderRadius.circular(15),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.transparent),
                borderRadius: BorderRadius.circular(15),
              ),
              errorBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.transparent),
                borderRadius: BorderRadius.circular(15),
              ),
              focusedErrorBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.transparent),
                borderRadius: BorderRadius.circular(15),
              ),
              filled: true,
              fillColor: backgroundFieldColor,
              labelText: 'Confirm Password',
              labelStyle: TextStyle(
                color: Colors.grey[600],
                fontFamily: 'Poppins',
                fontSize: 14,
              ),
            ),
            obscureText: _isConfirmPasswordHidden,
            validator: (value) => isFieldValid(value, "password"),
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
                ),
              ],
              borderRadius: BorderRadius.circular(25),
            ),
            child: FilledButton(
              onPressed: () async {
                if (_formGlobalKey.currentState!.validate()) {
                  if (_passwordController.text !=
                      _confirmPasswordController.text) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Passwords do not match.")),
                    );
                    return;
                  }
                }

                try {
                  UserCredential userCredential = await auth
                      .createUserWithEmailAndPassword(
                        email: _emailController.text.trim(),
                        password: _passwordController.text.trim(),
                      );

                  // Update display name
                  await userCredential.user!.updateDisplayName(
                    _usernameController.text.trim(),
                  );

                  // Navigate to home screen here
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Account created successfully!")),
                  );

                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => HomePage()),
                  );
                } on FirebaseAuthException catch (e) {
                  print("Failed with error code: ${e.code}");
                  print(e.message);

                  String message = e.message ?? "An unknown error occurred.";

                  if (e.code == 'email-already-in-use') {
                    message = "Email already in use.";
                  } else if (e.code == 'weak-password') {
                    message = "Password should be at least 6 characters";
                  }

                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(SnackBar(content: Text(message)));
                }
              },
              style: FilledButton.styleFrom(
                minimumSize: Size(double.infinity, 55),
                backgroundColor: Colors.deepOrange[400],
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
              ),
              child: Text("Sign up", style: TextStyle(fontSize: 18)),
            ),
          ),

          // Divider
          Row(
            children: [
              Expanded(child: Divider(color: Colors.grey[700], thickness: 2)),
              Padding(
                padding: EdgeInsetsDirectional.symmetric(
                  horizontal: 10,
                  vertical: 35,
                ),
                child: Text(
                  "Or continue with",
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
              ),
              Expanded(child: Divider(color: Colors.grey[700], thickness: 2)),
            ],
          ),

          // Google button
          OutlinedButton(
            onPressed: () {},
            style: OutlinedButton.styleFrom(
              backgroundColor: backgroundFieldColor,
              minimumSize: Size(double.infinity, 55),
              side: BorderSide(color: Colors.transparent, width: 0.5),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
            ),
            child: Text(
              'Continue with Google',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 16,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
