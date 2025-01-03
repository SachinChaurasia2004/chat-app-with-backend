import 'package:chat_app/features/chat/domain/entity/message_entity.dart';

abstract class MessagesRepository {
  Future<List<MessageEntity>> fetchMessages(String conversationId);
  Future<void> sendMessage(MessageEntity message);
}
