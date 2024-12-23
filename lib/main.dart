import 'package:chat_app/core/socket_service.dart';
import 'package:chat_app/features/chat/data/datasource/messages_remote_data_source.dart';
import 'package:chat_app/features/chat/data/repository/message_repo_impl.dart';
import 'package:chat_app/features/chat/domain/usecases/fetch_messages_usecase.dart';
import 'package:chat_app/features/chat/presentation/pages/bloc/chat_bloc.dart';
import 'package:chat_app/features/auth/data/datasource/auth_remote_datasource.dart';
import 'package:chat_app/features/auth/data/repository/auth_repo_impl.dart';
import 'package:chat_app/features/auth/domain/usecases/is_user_logged_in.dart.dart';
import 'package:chat_app/features/auth/domain/usecases/login_usecase.dart';
import 'package:chat_app/features/auth/domain/usecases/register_usecase.dart';
import 'package:chat_app/features/auth/presentation/pages/register_page.dart';
import 'package:chat_app/features/auth/presentation/pages/login_page.dart';
import 'package:chat_app/core/theme.dart';
import 'package:chat_app/features/conversation/data/datasource/convo_remote_data_source.dart';
import 'package:chat_app/features/conversation/data/repository/convo_repo_impl.dart';
import 'package:chat_app/features/conversation/domain/usecases/fetch_convos_usecase.dart';
import 'package:chat_app/features/conversation/presentation/bloc/conversation_bloc.dart';
import 'package:chat_app/features/conversation/presentation/pages/home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'features/auth/presentation/bloc/auth_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final socketService = SocketService();
  await socketService.initSocket();
  final authRepository =
      AuthRepositoryImpl(authRemoteDatasource: AuthRemoteDatasource());
  final convoRepository = ConversationRepositoryImpl(
      remoteDataSource: ConversationRemoteDataSource());
  final chatRepository =
      MessagesRepositoryImpl(remoteDataSource: MessagesRemoteDataSource());
  runApp(MyApp(
    authRepositoryImpl: authRepository,
    conversationRepositoryImpl: convoRepository,
    messagesRepositoryImpl: chatRepository,
  ));
}

class MyApp extends StatelessWidget {
  final AuthRepositoryImpl authRepositoryImpl;
  final ConversationRepositoryImpl conversationRepositoryImpl;
  final MessagesRepositoryImpl messagesRepositoryImpl;
  const MyApp({
    super.key,
    required this.authRepositoryImpl,
    required this.conversationRepositoryImpl,
    required this.messagesRepositoryImpl,
  });

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
        ),
        BlocProvider(
          create: (_) => ConversationBloc(
            FetchConversationsUseCase(conversationRepositoryImpl),
          ),
        ),
        BlocProvider(
          create: (_) => ChatBloc(
            FetchMessagesUseCase(messagesRepository: messagesRepositoryImpl),
          ),
        ),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.darkTheme,
        home: AuthWrapper(),
        routes: {
          '/login': (_) => LoginPage(),
          '/register': (_) => RegisterPage(),
          '/home': (_) => HomePage(),
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
          return const HomePage();
        } else if (state is AuthUnAuthenticated) {
          return const LoginPage();
        }
        return const Center(child: CircularProgressIndicator());
      },
    );
  }
}
