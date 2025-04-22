import 'package:dishedout/shared/widgets/navbar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:dishedout/services/auth.dart';

class Login extends StatelessWidget {
  const Login({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 20, 20, 20),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: IntrinsicHeight(
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
                      Expanded(
                        child: Center(
                          child: Padding(
                            padding: EdgeInsetsDirectional.symmetric(
                              vertical: 25,
                              horizontal: 25,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
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
                                Text(
                                  "Sign in",
                                  style: TextStyle(
                                    fontFamily: "Poppins",
                                    color: Colors.white,
                                    fontSize: 28,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 50),
                                SignupForm(),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
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

  late TextEditingController _passwordController;
  late TextEditingController _emailController;
  bool _showEmailClearButton = false;

  @override
  void initState() {
    super.initState();
    _passwordController = TextEditingController();
    _emailController = TextEditingController();

    _emailController.addListener(() {
      setState(() {
        _showEmailClearButton = _emailController.text.isNotEmpty;
      });
    });
  }

  @override
  void dispose() {
    _passwordController.dispose();
    _emailController.dispose();
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
          TextFormField(
            controller: _emailController,
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
                        icon: Icon(
                          Icons.clear,
                          color: Colors.white.withValues(alpha: 0.5),
                        ),
                        style: IconButton.styleFrom(
                          backgroundColor: Colors.transparent,
                        ),
                        onPressed: () {
                          _emailController.clear();
                          setState(() {
                            _showEmailClearButton = false;
                          });
                        },
                      )
                      : null,
              labelText: 'Email',
            ),
            validator: (value) => isFieldValid(value, "email"),
          ),
          SizedBox(height: 15),

          TextFormField(
            controller: _passwordController,
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
                  color: Colors.white.withValues(alpha: 0.5),
                ),
                style: IconButton.styleFrom(
                  backgroundColor: Colors.transparent,
                ),
                onPressed: () {
                  setState(() {
                    _isPasswordHidden = !_isPasswordHidden;
                  });
                },
              ),
              labelText: 'Password',
            ),
            obscureText: _isPasswordHidden,
            validator: (value) => isFieldValid(value, "password"),
          ),
          SizedBox(height: 15),

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
                _formGlobalKey.currentState!.validate();
                try {
                  await auth.signInWithEmailAndPassword(
                    email: _emailController.text.trim(),
                    password: _passwordController.text.trim(),
                  );

                  // Navigate to home screen here
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("You've logged in successfully!")),
                  );

                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => Navbar()),
                  );
                } on FirebaseAuthException catch (e) {
                  print("Failed with error code: ${e.code}");
                  print(e.message);

                  String message = e.message ?? "An unknown error occurred.";

                  if (e.code == 'email-already-in-use') {
                    message = "Email already in use.";
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
              child: Text("Sign in", style: TextStyle(fontSize: 18)),
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
