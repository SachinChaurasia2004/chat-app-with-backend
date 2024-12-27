import 'package:chat_app/features/conversation/domain/repository/convo_repo.dart';
import '../entities/convo_entity.dart';

class FetchConversationsUseCase {
  final ConversationRepository repository;

  FetchConversationsUseCase(this.repository);

  Future<List<ConversationEntity>> call() async {
    return await repository.fetchConversations();
  }
}
