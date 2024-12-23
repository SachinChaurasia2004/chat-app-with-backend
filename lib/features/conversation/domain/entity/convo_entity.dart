class ConversationEntity {
  final String id;
  final String userId;
  final String name;
  final String lastMessage;
  final DateTime lastMessageTime;

  ConversationEntity({
    required this.id,
    required this.userId,
    required this.name,
    required this.lastMessage,
    required this.lastMessageTime,
  });
}
