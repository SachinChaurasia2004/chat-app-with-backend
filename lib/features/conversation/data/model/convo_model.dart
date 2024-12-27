import '../../domain/entities/convo_entity.dart';

class ConversationModel extends ConversationEntity {
  ConversationModel({
    required super.id,
    super.userId,
    super.name,
    super.lastMessage,
    super.lastMessageTime,
  });

  factory ConversationModel.fromJson(Map<String, dynamic> json) {
    return ConversationModel(
      id: json['id'],
      userId: json['userId'],
      name: json['name'],
      lastMessage: json['lastMessage'],
      lastMessageTime: json['lastMessageTime'] != null
          ? DateTime.parse(json['lastMessageTime'])
          : null,
    );
  }
}
