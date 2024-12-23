import 'package:chat_app/core/socket_service.dart';
import 'package:chat_app/features/conversation/domain/entity/convo_entity.dart';
import 'package:chat_app/features/conversation/domain/usecases/fetch_convos_usecase.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'conversation_event.dart';
part 'conversation_state.dart';

class ConversationBloc extends Bloc<ConversationEvent, ConversationState> {
  final FetchConversationsUseCase fetchConversationsUseCase;
  final SocketService _socketService = SocketService();

  ConversationBloc(this.fetchConversationsUseCase)
      : super(ConversationInitial()) {
    on<FetchConversations>(_onFetchConversations);
    _initializeSocketListeners();
  }

  void _initializeSocketListeners() {
    try {
      _socketService.socket.on('conversationUpdated', _onConversationUpdated);
    } catch (e) {
      print('Error initializing socket listeners: $e');
    }
  }

  Future<void> _onFetchConversations(
      FetchConversations event, Emitter<ConversationState> emit) async {
    emit(ConversationLoading());
    try {
      final conversations = await fetchConversationsUseCase();
      emit(ConversationLoaded(conversations: conversations));
    } catch (error) {
      emit(ConversationError(error: "$error"));
    }
  }

  void _onConversationUpdated(data) {
    add(FetchConversations());
  }
}
