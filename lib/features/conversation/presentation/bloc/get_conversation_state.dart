part of 'get_conversation_bloc.dart';

@immutable
sealed class GetConversationState {}

final class GetConversationInitial extends GetConversationState {}

final class GetConversationLoading extends GetConversationState {}

final class GetConversationLoaded extends GetConversationState {
  final ConversationEntity conversationId;

  GetConversationLoaded({required this.conversationId});
}

final class GetConversationError extends GetConversationState {
  final String error;

  GetConversationError({required this.error});
}
