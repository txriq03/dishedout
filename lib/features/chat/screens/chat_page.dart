import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ChatPage extends ConsumerStatefulWidget {
  final String otherUserId;
  final String otherDisplayName;
  const ChatPage({
    super.key,
    required this.otherUserId,
    required this.otherDisplayName,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ChatPageState();
}

class _ChatPageState extends ConsumerState<ChatPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.otherDisplayName, style: TextStyle(fontSize: 28)),
        centerTitle: true,
      ),
    );
  }
}
