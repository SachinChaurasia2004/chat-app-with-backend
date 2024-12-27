import 'package:chat_app/core/theme.dart';
import 'package:chat_app/features/chat/presentation/pages/pages/chat_page.dart';
import 'package:chat_app/features/conversation/data/datasource/convo_remote_data_source.dart';
import 'package:chat_app/features/conversation/data/repository/convo_repo_impl.dart';
import 'package:chat_app/features/conversation/domain/usecases/getConversationId.dart';
import 'package:chat_app/features/conversation/presentation/bloc/conversation_bloc.dart';
import 'package:chat_app/features/conversation/presentation/bloc/get_conversation_bloc.dart';
import 'package:chat_app/features/conversation/presentation/bloc/get_users_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    BlocProvider.of<ConversationBloc>(context).add(FetchConversations());
    BlocProvider.of<GetUsersBloc>(context).add(GetUsers());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Messages',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        backgroundColor: Colors.transparent,
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.search),
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(10),
            child: Text(
              'Recent',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ),
          Container(
              height: 100,
              padding: EdgeInsets.all(5.0),
              child: BlocBuilder<GetUsersBloc, GetUsersState>(
                  builder: (context, state) {
                if (state is UsersLoaded) {
                  return ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: state.users.length,
                    itemBuilder: (context, index) {
                      final user = state.users[index];
                      return _buildRecentContact(
                        user.username,
                        user.id,
                        context,
                      );
                    },
                  );
                } else if (state is ErrorState) {
                  return Center(child: Text(state.message));
                }
                return Center(
                  child: Text("No User found"),
                );
              })),
          SizedBox(
            height: 10,
          ),
          Expanded(
              child: Container(
            decoration: BoxDecoration(
                color: DefaultColors.messageListPage,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(50),
                  topRight: Radius.circular(50),
                )),
            child: BlocBuilder<ConversationBloc, ConversationState>(
              builder: (context, state) {
                if (state is ConversationLoading) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (state is ConversationLoaded) {
                  return ListView.builder(
                    itemCount: state.conversations.length,
                    itemBuilder: (context, index) {
                      final conversation = state.conversations[index];
                      return _buildMessageTile(
                        conversation.name ?? '',
                        conversation.lastMessage ?? '',
                        conversation.lastMessageTime.toString(),
                        conversation.id,
                      );
                    },
                  );
                } else if (state is ConversationError) {
                  return Center(child: Text(state.error));
                }
                return Center(
                  child: Text("No Conversations found"),
                );
              },
            ),
          ))
        ],
      ),
    );
  }

  Widget _buildRecentContact(String name, String id, BuildContext context) {
    return BlocProvider(
      create: (context) => GetConversationBloc(GetConversationIdUseCase(
          repository: ConversationRepositoryImpl(
              remoteDataSource: ConversationRemoteDataSource()))),
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.0),
          child: BlocConsumer<GetConversationBloc, GetConversationState>(
            listener: (context, state) {
              if (state is GetConversationLoaded) {
                final convoId = state.conversationId.id;
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ChatPage(
                      conversationId: convoId,
                      name: name,
                    ),
                  ),
                );
              }
            },
            builder: (context, state) {
              return GestureDetector(
                onTap: () {
                  context.read<GetConversationBloc>().add(
                        GetConversationId(otherUserId: id),
                      );
                },
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 30,
                      backgroundImage: NetworkImage(
                          'https://avatar.iran.liara.run/public/boy'),
                    ),
                    SizedBox(height: 5),
                    Text(
                      name,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    if (state is GetConversationLoading)
                      Padding(
                        padding: const EdgeInsets.only(top: 5),
                        child: CircularProgressIndicator(),
                      ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildMessageTile(
      String name, String message, String time, String conversationId) {
    return ListTile(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ChatPage(
                conversationId: conversationId,
                name: name,
              ),
            ));
      },
      contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      leading: CircleAvatar(
        radius: 30,
        backgroundImage: NetworkImage('https://avatar.iran.liara.run/public'),
      ),
      title: Text(
        name,
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
      subtitle: Text(
        message,
        style: TextStyle(
          color: Colors.grey,
        ),
        overflow: TextOverflow.ellipsis,
      ),
      trailing: Text(
        time,
        style: TextStyle(color: Colors.grey),
      ),
    );
  }
}
