import 'package:chat_app/features/auth/data/datasource/auth_remote_datasource.dart';
import 'package:chat_app/features/auth/domain/entity/user_entity.dart';
import 'package:chat_app/features/auth/domain/repository/auth_repo.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDatasource authRemoteDatasource;

  AuthRepositoryImpl({required this.authRemoteDatasource});

  @override
  Future<UserEntity> login(String email, String password) async {
    return await authRemoteDatasource.login(email: email, password: password);
  }

  @override
  Future<UserEntity> register(
      String username, String email, String password) async {
    return await authRemoteDatasource.register(
        username: username, email: email, password: password);
  }

  @override
  Future<UserEntity?> isUserLoggedIn() async {
    return await authRemoteDatasource.fetchUser();
  }
}
