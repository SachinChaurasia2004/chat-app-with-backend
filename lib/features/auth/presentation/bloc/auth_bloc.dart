import 'package:chat_app/features/auth/domain/usecases/is_user_logged_in.dart.dart';
import 'package:chat_app/features/auth/domain/usecases/login_usecase.dart';
import 'package:chat_app/features/auth/domain/usecases/register_usecase.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter/material.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final RegisterUsecase registerUsecase;
  final LoginUsecase loginUsecase;
  final IsUserLoggedInUseCase isUserLoggedInUseCase;
  final _storage = FlutterSecureStorage();

  AuthBloc(
      {required this.isUserLoggedInUseCase,
      required this.registerUsecase,
      required this.loginUsecase})
      : super(AuthInitial()) {
    on<RegisterEvent>(_onRegister);
    on<LoginEvent>(_onLogin);
    on<IsUserLoggedIn>(_onAppStarted);
  }

  Future<void> _onRegister(RegisterEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      final user = await registerUsecase.call(
          event.username, event.email, event.password);
      await _storage.write(key: 'token', value: user.token);
      emit(AuthAuthenticated());
    } catch (e) {
      emit(AuthError(error: " $e"));
    }
  }

  Future<void> _onLogin(LoginEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      final user = await loginUsecase.call(event.email, event.password);
      await _storage.write(key: 'token', value: user.token);
      emit(AuthAuthenticated());
    } catch (e) {
      emit(AuthError(error: " $e"));
    }
  }

  Future<void> _onAppStarted(
      IsUserLoggedIn event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      final isLoggedIn = await isUserLoggedInUseCase.call();
      if (isLoggedIn != null) {
        emit(AuthAuthenticated());
      } else {
        emit(AuthUnAuthenticated());
      }
    } catch (e) {
      emit(AuthUnAuthenticated());
    }
  }
}
