import 'package:chat_app/features/conversation/domain/entities/users_entity.dart';

import '../repository/convo_repo.dart';

class GetallUsersUseCase {
  final ConversationRepository repository;

  GetallUsersUseCase({required this.repository});

  Future<List<UsersEntity>> call() async {
    return await repository.getAllUsers();
  }
}
