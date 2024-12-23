import 'package:chat_app/features/chat/domain/entity/message_entity.dart';

class MessageModel extends MessageEntity {
  MessageModel({
    required super.id,
    required super.conversationId,
    required super.senderId,
    required super.content,
    required super.createdAt,
  });

  factory MessageModel.fromJson(Map<String, dynamic> json) {
    return MessageModel(
      id: json['_id'],
      conversationId: json['conversationId'],
      senderId: json['senderId'],
      content: json['content'],
      createdAt: json['createdAt'],
    );
  }
}
