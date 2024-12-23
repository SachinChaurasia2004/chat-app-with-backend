import 'package:chat_app/core/socket_service.dart';
import 'package:chat_app/features/chat/domain/entity/message_entity.dart';
import 'package:chat_app/features/chat/domain/usecases/fetch_messages_usecase.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

part 'chat_event.dart';
part 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final FetchMessagesUseCase fetchMessagesUseCase;
  final FlutterSecureStorage _storage = FlutterSecureStorage();
  final SocketService _socketService = SocketService();
  final List<MessageEntity> _messages = [];

  ChatBloc(this.fetchMessagesUseCase) : super(ChatInitial()) {
    on<LoadMessagesEvent>(_onLoadMessages);
    on<SendMessageEvent>(_onSendMessage);
    on<ReceiveMessageEvent>(_onReceiveMessage);
  }

  Future<void> _onLoadMessages(
      LoadMessagesEvent event, Emitter<ChatState> emit) async {
    emit(ChatLoading());
    try {
      final messages = await fetchMessagesUseCase(event.conversationId);
      _messages.clear();
      _messages.addAll(messages);
      emit(ChatLoaded(messages: List.from(_messages)));

      _socketService.socket.emit('joinConversation', event.conversationId);
      _socketService.socket.off('newMessage');
      _socketService.socket.on(
        'newMessage',
        (data) => {add(ReceiveMessageEvent(data))},
      );
    } catch (e) {
      emit(
        ChatErrorState(message: "$e"),
      );
    }
  }

  Future<void> _onSendMessage(
      SendMessageEvent event, Emitter<ChatState> emit) async {
    String userId = await _storage.read(key: 'userId') ?? '';
    try {
      final newMessage = {
        'conversationId': event.conversationId,
        'content': event.content,
        'senderId': userId,
      };
      _socketService.socket.emit('sendMessage', newMessage);
    } catch (e) {
      emit(ChatErrorState(message: e.toString()));
    }
  }

  Future<void> _onReceiveMessage(
      ReceiveMessageEvent event, Emitter<ChatState> emit) async {
    final message = MessageEntity(
      id: event.message['_id'],
      conversationId: event.message['conversationId'],
      senderId: event.message['senderId'],
      content: event.message['content'],
      createdAt: event.message['createdAt'],
    );
    _messages.add(message);
    emit(ChatLoaded(messages: List.from(_messages)));
  }
}
