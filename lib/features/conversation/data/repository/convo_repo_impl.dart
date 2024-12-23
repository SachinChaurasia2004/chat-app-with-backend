import 'package:chat_app/features/conversation/data/datasource/convo_remote_data_source.dart';
import 'package:chat_app/features/conversation/domain/entity/convo_entity.dart';
import 'package:chat_app/features/conversation/domain/repository/convo_repo.dart';

class ConversationRepositoryImpl implements ConversationRepository {
  final ConversationRemoteDataSource remoteDataSource;

  ConversationRepositoryImpl({required this.remoteDataSource});
  @override
  Future<List<ConversationEntity>> fetchConversations() async {
    return await remoteDataSource.fetchConversations();
  }
}
