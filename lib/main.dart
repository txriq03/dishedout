import 'package:dishedout/shared/widgets/navbar.dart';
import 'package:flutter/material.dart';
import 'package:dishedout/features/authentication/auth_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:dishedout/services/auth.dart';
import 'package:flutter/services.dart';
import 'package:dishedout/config/themes/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // LOck the app orientation to portrait
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});
  final Auth _auth = Auth();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: appTheme,
      debugShowCheckedModeBanner: false,
      home: StreamBuilder<User?>(
        stream: _auth.authStateChanges,
        builder: (context, snapshot) {
          print('Snapshot data: ${snapshot.data}');
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasData) {
            print('========== USER IS LOGGED IN ==========');
            return Navbar(); // Logged in
          }

          print('========== USER IS LOGGED OUT ==========');
          return AuthPage();
        },
      ),
    );
  }
}
