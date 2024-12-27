part of 'get_conversation_bloc.dart';

@immutable
sealed class GetConversationEvent {}

class GetConversationId extends GetConversationEvent {
  final String otherUserId;

  GetConversationId({required this.otherUserId});
}
