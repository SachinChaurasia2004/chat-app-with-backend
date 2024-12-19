import 'package:chat_app/features/auth/domain/entity/user_entity.dart';
import 'package:chat_app/features/auth/domain/repository/auth_repo.dart';

class IsUserLoggedInUseCase {
  final AuthRepository repository;
  IsUserLoggedInUseCase({required this.repository});

  Future<UserEntity?> call() {
    return repository.isUserLoggedIn();
  }
}
