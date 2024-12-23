part of 'conversation_bloc.dart';

@immutable
sealed class ConversationEvent {}

class FetchConversations extends ConversationEvent {}
