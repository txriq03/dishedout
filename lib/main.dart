import 'package:dishedout/features/onboarding/screens/onboarding_page.dart';
import 'package:dishedout/providers/auth_provider.dart';
import 'package:dishedout/services/notification_service.dart';
import 'package:dishedout/shared/widgets/navbar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:dishedout/features/authentication/screens/auth_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'firebase_options.dart';
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

  // Check if onboarding is complete
  final prefs = await SharedPreferences.getInstance();
  final showOnboarding = !(prefs.getBool('onboarding_complete') ?? false);

  runApp(ProviderScope(child: MyApp(showOnboarding: showOnboarding)));
}

class MyApp extends ConsumerStatefulWidget {
  final bool showOnboarding;
  const MyApp({super.key, required this.showOnboarding});

  @override
  ConsumerState<MyApp> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> {
  @override
  void initState() {
    super.initState();

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
    final authState = ref.watch(authNotifierProvider);
    // final user = authState.asData?.value;
    final showOnboarding = widget.showOnboarding;
    final User? user = FirebaseAuth.instance.currentUser;

    return MaterialApp(
      theme: appTheme,
      title: 'DishedOut',
      debugShowCheckedModeBanner: false,
      home:
          user != null
              ? Navbar()
              : showOnboarding
              ? OnboardingPage()
              : AuthPage(),
    );
  }
}
