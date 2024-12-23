import 'package:chat_app/features/chat/data/datasource/messages_remote_data_source.dart';
import 'package:chat_app/features/chat/domain/entity/message_entity.dart';

import '../../domain/repository/message_repo.dart';

class MessagesRepositoryImpl implements MessagesRepository {
  final MessagesRemoteDataSource remoteDataSource;

  MessagesRepositoryImpl({required this.remoteDataSource});
  @override
  Future<List<MessageEntity>> fetchMessages(String conversationId) async {
    return await remoteDataSource.fetchMessages(conversationId);
  }

  @override
  Future<void> sendMessage(MessageEntity message) {
    // TODO: implement sendMessage
    throw UnimplementedError();
  }
}
