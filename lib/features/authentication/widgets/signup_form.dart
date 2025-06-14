import 'package:dishedout/providers/auth_provider.dart';
import 'package:dishedout/services/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SignupForm extends ConsumerStatefulWidget {
  const SignupForm({super.key});

  @override
  ConsumerState<SignupForm> createState() => _SignupFormState();
}

class _SignupFormState extends ConsumerState<SignupForm> {
  final auth = AuthService();

  final GlobalKey<FormState> _formGlobalKey = GlobalKey<FormState>();
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

  void _handleSubmit(BuildContext context) async {
    if (_formGlobalKey.currentState!.validate()) {
      if (_passwordController.text != _confirmPasswordController.text) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Passwords do not match.")));
        return;
      }
    }

    try {
      await ref
          .read(authNotifierProvider.notifier)
          .signUp(
            _usernameController.text.trim(),
            _emailController.text.trim(),
            _passwordController.text.trim(),
          );

      // Navigate to home screen here
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Account created successfully!")));

      Navigator.pop(context);
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
    final authState = ref.watch(authNotifierProvider);
    final isLoading = authState is AsyncLoading;
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
              prefixIcon: Icon(
                Icons.account_circle,
                color: Colors.grey[600],
                semanticLabel: 'Input display name here',
              ),
              suffixIcon:
                  _showUsernameClearButton
                      ? IconButton(
                        icon: Icon(
                          Icons.clear,
                          color: Colors.white.withValues(alpha: 0.5),
                        ),
                        style: IconButton.styleFrom(
                          backgroundColor: Colors.transparent,
                        ),

                        onPressed: () {
                          _usernameController.clear();
                          setState(() {
                            _showUsernameClearButton = false;
                          });
                        },
                      )
                      : null,
              labelText: 'Display name',
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

          // Password field
          TextFormField(
            controller: _passwordController,
            style: TextStyle(color: Colors.white),
            cursorColor: Colors.deepOrange,
            decoration: InputDecoration(
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

          // Confirm password field
          TextFormField(
            controller: _confirmPasswordController,
            style: TextStyle(color: Colors.white),
            cursorColor: Colors.deepOrange,
            decoration: InputDecoration(
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
                  color: Colors.white.withValues(alpha: 0.5),
                ),
                style: IconButton.styleFrom(
                  backgroundColor: Colors.transparent,
                ),
                onPressed: () {
                  setState(() {
                    _isConfirmPasswordHidden = !_isConfirmPasswordHidden;
                  });
                },
              ),
              labelText: 'Confirm Password',
            ),
            obscureText: _isConfirmPasswordHidden,
            validator: (value) => isFieldValid(value, "password"),
          ),
          SizedBox(height: 35),

          // Sign up button
          Container(
            decoration: BoxDecoration(
              boxShadow: [
                if (!isLoading)
                  BoxShadow(
                    color: Colors.deepOrange.withValues(alpha: 0.5),
                    blurRadius: 15,
                    spreadRadius: 0.1,
                  ),
              ],
              borderRadius: BorderRadius.circular(25),
            ),
            child: FilledButton(
              onPressed:
                  isLoading
                      ? null
                      : () {
                        _handleSubmit(context);
                      },
              style: FilledButton.styleFrom(
                minimumSize: Size(double.infinity, 55),
                backgroundColor: Colors.deepOrange[400],
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
              ),
              child:
                  isLoading
                      ? SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color:
                              Theme.of(context).colorScheme.secondaryContainer,
                        ),
                      )
                      : Text("Sign up", style: TextStyle(fontSize: 18)),
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
