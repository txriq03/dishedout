import 'package:dishedout/models/message_model.dart';
import 'package:flutter/material.dart';

class ChatBubble extends StatelessWidget {
  final MessageModel message;
  final bool isCurrentUser;
  const ChatBubble({
    super.key,
    required this.message,
    required this.isCurrentUser,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color:
            isCurrentUser ? Theme.of(context).colorScheme.primary : Colors.pink,
      ),
      child: Text(message.text),
    );
  }
}
