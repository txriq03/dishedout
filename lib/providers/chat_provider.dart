import 'package:dishedout/services/chat_service.dart';
import 'package:dishedout/models/message_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'chat_provider.g.dart';

@riverpod
Stream<List<MessageModel>> messageStream(Ref ref, String otherUserId) {
  ChatService chatService = ChatService();
  return chatService.getMessageStream(otherUserId);
}
