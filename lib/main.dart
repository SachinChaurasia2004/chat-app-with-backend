import 'package:chat_app/chat_page.dart';
import 'package:chat_app/features/auth/data/datasource/auth_remote_datasource.dart';
import 'package:chat_app/features/auth/data/repository/auth_repo_impl.dart';
import 'package:chat_app/features/auth/domain/usecases/is_user_logged_in.dart.dart';
import 'package:chat_app/features/auth/domain/usecases/login_usecase.dart';
import 'package:chat_app/features/auth/domain/usecases/register_usecase.dart';
import 'package:chat_app/features/auth/presentation/pages/register_page.dart';
import 'package:chat_app/features/auth/presentation/pages/login_page.dart';
import 'package:chat_app/core/theme.dart';
import 'package:chat_app/message_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'features/auth/presentation/bloc/auth_bloc.dart';

void main() {
  final authRepository =
      AuthRepositoryImpl(authRemoteDatasource: AuthRemoteDatasource());
  runApp(MyApp(
    authRepositoryImpl: authRepository,
  ));
}

class MyApp extends StatelessWidget {
  final AuthRepositoryImpl authRepositoryImpl;
  const MyApp({super.key, required this.authRepositoryImpl});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => AuthBloc(
            registerUsecase: RegisterUsecase(repository: authRepositoryImpl),
            loginUsecase: LoginUsecase(repository: authRepositoryImpl),
            isUserLoggedInUseCase:
                IsUserLoggedInUseCase(repository: authRepositoryImpl),
          ),
        )
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.darkTheme,
        home: AuthWrapper(),
        routes: {
          '/login': (_) => LoginPage(),
          '/register': (_) => RegisterPage(),
          '/chat': (_) => ChatPage(),
          '/message': (_) => MessagePage(),
        },
      ),
    );
  }
}

class AuthWrapper extends StatefulWidget {
  @override
  State<AuthWrapper> createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<AuthWrapper> {
  @override
  void initState() {
    super.initState();
    context.read<AuthBloc>().add(IsUserLoggedIn());
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        if (state is AuthAuthenticated) {
          return const MessagePage();
        } else if (state is AuthUnAuthenticated) {
          return const LoginPage();
        }
        return const Center(child: CircularProgressIndicator());
      },
    );
  }
}
