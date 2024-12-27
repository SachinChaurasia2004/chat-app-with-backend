import 'package:chat_app/features/conversation/domain/entities/convo_entity.dart';
import 'package:chat_app/features/conversation/domain/entities/users_entity.dart';

abstract class ConversationRepository {
  Future<List<ConversationEntity>> fetchConversations();
  Future<List<UsersEntity>> getAllUsers();
  Future<ConversationEntity> fetchConversationId(String otherUserId);
}
