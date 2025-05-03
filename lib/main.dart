import 'package:dishedout/features/authentication/providers/user_provider.dart';
import 'package:dishedout/services/notification_service.dart';
import 'package:dishedout/shared/widgets/navbar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:dishedout/features/authentication/presentation/screens/auth_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'firebase_options.dart';
import 'package:dishedout/services/auth.dart';
import 'package:flutter/services.dart';
import 'package:dishedout/config/themes/app_theme.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  print('Handling a background message: ${message.messageId}');
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Handle background messages
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  // Lock the app orientation to portrait
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  // Enable edge-to-edge system UI
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);

  // Make nav and status bars transparent
  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(
      systemNavigationBarColor: Colors.transparent,
      systemNavigationBarIconBrightness: Brightness.light,
    ),
  );
  // Request permissions
  await FirebaseMessaging.instance.requestPermission();

  // Initialise local notifications
  await initLocalNotifications();

  runApp(ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key});

  @override
  ConsumerState<MyApp> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> {
  final Auth _auth = Auth();

  Future<void> _checkUser() async {
    final User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      try {
        // Force refresh the ID token
        await user.getIdToken(true);
      } catch (e) {
        print("Token refresh failed. Signing out...");
        await FirebaseAuth.instance.signOut();
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _checkUser();

    // Listen to foreground messages
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Got a message in the foreground!');
      if (message.notification != null) {
        showLocalNotification(message);
        saveNotification(
          title: message.notification?.title,
          body: message.notification?.body,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: appTheme,
      debugShowCheckedModeBanner: false,
      home: StreamBuilder<User?>(
        stream: _auth.authStateChanges,
        builder: (context, snapshot) {
          print('SNAPSHOT DATA: ${snapshot.data}');
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          final currentUser = ref.watch(currentUserProvider);
          print('CURRENT USER: $currentUser');

          if (snapshot.hasData) {
            return currentUser.when(
              data: (user) {
                if (user == null) {
                  return Center(
                    child: CircularProgressIndicator(),
                  ); // Loading user
                }
                return Navbar();
              },
              loading: () => Center(child: CircularProgressIndicator()),
              error: (e, _) => Center(child: Text('Error loading user')),
            );
          }

          print('========== USER IS LOGGED OUT ==========');

          // ref.read(currentUserProvider.notifier).clearUser();
          return AuthPage();
        },
      ),
    );
  }
}
