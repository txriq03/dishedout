import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ChatService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Gets the chat room ID
  String _getChatId(String userID1, String userID2) {
    final sorted = [userID1, userID2]..sort();
    return '${sorted[0]}_${sorted[1]}';
  }

  // Sends a message as the current user
  Future<void> sendMessage({
    required String receiverId,
    required String message,
  }) async {
    final currentUser = _auth.currentUser;
    if (currentUser == null) throw Exception('User not logged in.');

    final chatId = _getChatId(currentUser.uid, receiverId);

    final messageRef =
        _firestore.collection('chats').doc(chatId).collection('messages').doc();
  }
}
