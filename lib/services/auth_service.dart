import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
export 'package:firebase_auth/firebase_auth.dart' show User;

class AuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  User? get currentUser => _firebaseAuth.currentUser;

  /* 
  Subscribes and listens to changes for user's authentication state.
  Emits User object when logged in, and emits null when logged out
  */
  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

  // Updated FCM token
  void _handleFCMTokenRefresh(User user) {
    FirebaseMessaging.instance.onTokenRefresh.listen((newToken) async {
      await FirebaseFirestore.instance.collection('users').doc(user.uid).update(
        {'fcmToken': newToken},
      );
    });
  }

  // Login the user
  Future<UserCredential> login({
    required String email,
    required String password,
  }) async {
    UserCredential credential = await _firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    _handleFCMTokenRefresh(credential.user!);
    return credential;
  }

  // Create a new user
  Future<UserCredential> signUp({
    required String email,
    required String password,
  }) async {
    UserCredential credential = await _firebaseAuth
        .createUserWithEmailAndPassword(email: email, password: password);
    _handleFCMTokenRefresh(credential.user!);
    return credential;
  }

  // Sign out the user
  Future<void> signOut() async {
    await FirebaseMessaging.instance.deleteToken();
    await _firebaseAuth.signOut();
  }
}
