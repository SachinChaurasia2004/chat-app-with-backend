import 'package:chat_app/features/chat/domain/entity/message_entity.dart';
import 'package:chat_app/features/chat/domain/repository/message_repo.dart';

class FetchMessagesUseCase {
  final MessagesRepository messagesRepository;

  FetchMessagesUseCase({required this.messagesRepository});

  Future<List<MessageEntity>> call(String conversationId) async {
    return await messagesRepository.fetchMessages(conversationId);
  }
}
