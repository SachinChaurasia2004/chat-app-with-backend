part of 'get_users_bloc.dart';

@immutable
sealed class GetUsersState {}

final class GetUsersInitial extends GetUsersState {}

final class UsersLoading extends GetUsersState {}

final class UsersLoaded extends GetUsersState {
  final List<UsersEntity> users;

  UsersLoaded({required this.users});
}

final class ErrorState extends GetUsersState {
  final String message;

  ErrorState({required this.message});
}
