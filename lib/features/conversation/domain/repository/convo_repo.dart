import 'package:chat_app/features/conversation/domain/entity/convo_entity.dart';

abstract class ConversationRepository {
  Future<List<ConversationEntity>> fetchConversations();
}
