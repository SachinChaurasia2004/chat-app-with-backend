part of 'auth_bloc.dart';

@immutable
sealed class AuthState {}

final class AuthInitial extends AuthState {}

final class AuthLoading extends AuthState {}

final class AuthAuthenticated extends AuthState {}

final class AuthUnAuthenticated extends AuthState {}

final class AuthError extends AuthState {
  final String error;

  AuthError({required this.error});
}
