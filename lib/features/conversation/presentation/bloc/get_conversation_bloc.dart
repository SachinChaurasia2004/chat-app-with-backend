import 'package:chat_app/features/conversation/domain/entities/convo_entity.dart';
import 'package:chat_app/features/conversation/domain/usecases/getConversationId.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'get_conversation_event.dart';
part 'get_conversation_state.dart';

class GetConversationBloc
    extends Bloc<GetConversationEvent, GetConversationState> {
  final GetConversationIdUseCase getConversationId;

  GetConversationBloc(this.getConversationId)
      : super(GetConversationInitial()) {
    on<GetConversationId>(_onGetConversationId);
  }

  Future<void> _onGetConversationId(
      GetConversationId event, Emitter<GetConversationState> emit) async {
    emit(GetConversationLoading());

    try {
      final conversation = await getConversationId(event.otherUserId);
      emit(GetConversationLoaded(conversationId: conversation));
    } catch (error) {
      emit(GetConversationError(error: error.toString()));
    }
  }
}
