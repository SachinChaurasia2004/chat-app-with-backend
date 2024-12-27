import 'package:chat_app/features/conversation/domain/entities/users_entity.dart';

class UsersModel extends UsersEntity {
  UsersModel({
    required super.id,
    required super.username,
    required super.email,
  });

  factory UsersModel.fromJson(Map<String, dynamic> json) {
    return UsersModel(
      id: json['_id'],
      username: json['username'],
      email: json['username'],
    );
  }
}
