import '../entities/convo_entity.dart';
import '../repository/convo_repo.dart';

class GetConversationIdUseCase {
  final ConversationRepository repository;

  GetConversationIdUseCase({required this.repository});

  Future<ConversationEntity> call(String otherUserId) async {
    return await repository.fetchConversationId(otherUserId);
  }
}
