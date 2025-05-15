import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dishedout/models/message_model.dart';
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
    required String text,
  }) async {
    final currentUser = _auth.currentUser;
    if (currentUser == null) throw Exception('User not logged in.');

    final chatId = _getChatId(currentUser.uid, receiverId);

    final messageRef =
        _firestore.collection('chats').doc(chatId).collection('messages').doc();

    final message = MessageModel(
      id: messageRef.id,
      senderId: currentUser.uid,
      receiverId: receiverId,
      text: text,
      timestamp: Timestamp.now(),
    );

    await messageRef.set(message.toMap());
  }

  // Get message stream between the two users
  Stream<List<MessageModel>> getMessageStream(String otherUserId) {
    final currentUser = _auth.currentUser;
    if (currentUser == null) throw Exception('User not logged in');

    final chatId = _getChatId(currentUser.uid, otherUserId);
    return _firestore
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .orderBy('timestamp', descending: false)
        .snapshots()
        .map(
          (snapshot) =>
              snapshot.docs
                  .map((doc) => MessageModel.fromDocument(doc))
                  .toList(),
        );
  }
}
