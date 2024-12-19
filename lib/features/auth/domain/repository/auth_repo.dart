import 'package:chat_app/features/auth/domain/entity/user_entity.dart';

abstract class AuthRepository {
  Future<UserEntity> login(String email, String password);
  Future<UserEntity> register(String username, String email, String password);
  Future<UserEntity?> isUserLoggedIn();
}
