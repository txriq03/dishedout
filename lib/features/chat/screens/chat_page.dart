import 'package:dishedout/models/user_model.dart';
import 'package:dishedout/providers/chat_provider.dart';
import 'package:dishedout/services/chat_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ChatPage extends ConsumerStatefulWidget {
  final UserModel otherUser;

  const ChatPage({super.key, required this.otherUser});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ChatPageState();
}

class _ChatPageState extends ConsumerState<ChatPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _controller = TextEditingController();
  final ChatService _chatService = ChatService();

  void _sendMessage() async {
    final text = _controller.text.trim();
    if (text.isNotEmpty) {
      await _chatService.sendMessage(
        receiverId: widget.otherUser.uid,
        text: text,
      );
      _controller.clear();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = _auth.currentUser;
    final messageStream = ref.watch(
      messageStreamProvider(widget.otherUser.uid),
    );

    if (currentUser == null) {
      return const Scaffold(body: Center(child: Text("User not logged in")));
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.otherUser.displayName,
          style: TextStyle(fontSize: 28),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: messageStream.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error:
                  (e, _) => Center(child: Text("Error loading messages: $e")),
              data: (messages) {
                if (messages.isEmpty) {
                  return const Center(child: Text("Start the conversation"));
                }

                return Center(child: Text("Still in development"));
              },
            ),
          ),
          SafeArea(
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 10),
              margin: EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      decoration: const InputDecoration(
                        hintText: "Type a message...",
                        border: OutlineInputBorder(),
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 15,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    icon: Icon(
                      Icons.send,
                      color: Theme.of(context).colorScheme.secondaryContainer,
                    ),
                    onPressed: () => _sendMessage(),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
