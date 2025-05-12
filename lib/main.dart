import 'package:dishedout/providers/auth_gate_provider.dart';
import 'package:dishedout/providers/auth_provider.dart';
import 'package:dishedout/services/notification_service.dart';
import 'package:dishedout/shared/widgets/navbar.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:dishedout/features/authentication/screens/auth_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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

  runApp(ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key});

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
    final isAuthorised = ref.watch(isAuthorisedProvider);
    final authState = ref.watch(authNotifierProvider);
    print('isAuthorised: $isAuthorised');

    if (isAuthorised) {
      print("User is authorised.");
    } else {
      print("User is not authorised.");
    }

    return MaterialApp(
      theme: appTheme,
      title: 'DishedOut',
      debugShowCheckedModeBanner: false,
      home: authState.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error:
            (e, _) => Center(
              child: Text('Error: $e', style: TextStyle(fontSize: 24)),
            ),
        data: (user) {
          if (user != null) {
            return const Navbar();
          } else {
            return const AuthPage();
          }
        },
      ),
    );
  }
}
