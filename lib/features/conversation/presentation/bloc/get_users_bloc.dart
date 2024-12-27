import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/users_entity.dart';
import '../../domain/usecases/getAllUsersUseCase.dart';

part 'get_users_event.dart';
part 'get_users_state.dart';

class GetUsersBloc extends Bloc<GetUsersEvent, GetUsersState> {
  final GetallUsersUseCase getallUsersUseCase;
  GetUsersBloc(this.getallUsersUseCase) : super(GetUsersInitial()) {
    on<GetUsers>((event, emit) async {
      emit(UsersLoading());
      try {
        final allUsers = await getallUsersUseCase();
        emit(UsersLoaded(users: allUsers));
      } catch (error) {
        emit(ErrorState(message: "$error"));
      }
    });
  }
}
