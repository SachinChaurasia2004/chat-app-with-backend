part of 'conversation_bloc.dart';

@immutable
sealed class ConversationState {}

final class ConversationInitial extends ConversationState {}

final class ConversationLoading extends ConversationState {}

final class ConversationLoaded extends ConversationState {
  final List<ConversationEntity> conversations;

  ConversationLoaded({required this.conversations});
}

final class ConversationError extends ConversationState {
  final String error;

  ConversationError({required this.error});
}
