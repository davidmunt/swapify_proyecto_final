import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart';
import 'package:swapify/domain/entities/user.dart';
import 'package:image_picker/image_picker.dart';
import 'package:swapify/presentation/blocs/chat/chat_bloc.dart';
import 'package:swapify/presentation/blocs/chat/chat_event.dart';
import 'package:swapify/presentation/blocs/user/user_bloc.dart';
import 'package:swapify/presentation/blocs/user/user_state.dart';
import 'package:swapify/presentation/widgets/alertdialog_show_image_chat.dart';
import 'package:swapify/presentation/widgets/widget_send_message.dart';

class ChatScreen extends StatefulWidget {
  final String productOwnerId;
  final String potBuyerId;
  final int productId;

  const ChatScreen({
    super.key,
    required this.productOwnerId,
    required this.potBuyerId,
    required this.productId,
  });

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  late String chatId;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    chatId = "${widget.productOwnerId}${widget.potBuyerId}${widget.productId}";
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToBottom();
    });
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
    }
  }

  void _sendMessage(String message, XFile? image) {
    final userId = context.read<UserBloc>().state.user!.id;
    context.read<ChatBloc>().add(
          SendMessageButtonPressed(
            productOwnerId: widget.productOwnerId,
            potBuyerId: widget.potBuyerId,
            productId: widget.productId,
            message: message.isEmpty ? null : message,
            image: image,
            senderId: userId,
            dateMessageSent: DateTime.now(),
          ),
        );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToBottom();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: BlocBuilder<UserBloc, UserState>(
          builder: (context, userState) {
            if (userState.isLoading) {
              return const CircularProgressIndicator();
            } else if (userState.users != null && userState.users!.isNotEmpty) {
              final otherUserId = userState.user!.id == widget.productOwnerId ? widget.potBuyerId : widget.productOwnerId;
              final otherUser = userState.users!.firstWhere(
                (user) => user.id == otherUserId,
                orElse: () => UserEntity(
                  id: "unknown",
                  email: "unknown",
                  name: "Usuario desconocido",
                  surname: null,
                  telNumber: null,
                  avatarId: null,
                  dateBirth: null,
                  linkAvatar: null,
                ),
              );
              final baseUrl = dotenv.env['BASE_API_URL'] ?? 'http://localhost:3000';
              final avatar = otherUser.linkAvatar != null ? NetworkImage("$baseUrl${otherUser.linkAvatar}") : null;
              return Row(
                children: [
                  CircleAvatar(
                    backgroundImage: avatar,
                    child: avatar == null ? const Icon(Icons.person) : null,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    otherUser.name ?? AppLocalizations.of(context)!.unknownUser,
                    style: const TextStyle(fontSize: 18, overflow: TextOverflow.ellipsis),
                  ),
                ],
              );
            } else {
              return Text(AppLocalizations.of(context)!.chat);
            }
          },
        ),
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance.collection('chats').doc(chatId).snapshots(),
        builder: (context, snapshot) {
          final userId = context.read<UserBloc>().state.user!.id;
          if (!snapshot.hasData || !snapshot.data!.exists) {
            return Column(
              children: [
                Expanded(
                  child: Center(
                    child: Text(AppLocalizations.of(context)!.chatNotYetStarted),
                  ),
                ),
                SendMessageWidget(onSendMessage: _sendMessage),
              ],
            );
          }
          final chatData = snapshot.data!.data() as Map<String, dynamic>;
          final messages = List<Map<String, dynamic>>.from(chatData['messages'] ?? []);
          WidgetsBinding.instance.addPostFrameCallback((_) {
            _scrollToBottom();
          });
          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  controller: _scrollController,
                  padding: const EdgeInsets.all(16),
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final message = messages[index];
                    final isSender = message['senderId'] == userId;
                    Widget messageContent;
                    if (message['imagePath'] != null && message['imagePath'].trim().isNotEmpty) {
                      messageContent = GestureDetector(
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertShowImageChat(imagenMostrar: message['imagePath']);
                            },
                          );
                        },
                        child: Image.network(
                          "${dotenv.env['BASE_API_URL']}${message['imagePath']}",
                          width: 200,
                          height: 250,
                          fit: BoxFit.cover,
                        ),
                      );
                    } else {
                      messageContent = Text(
                        message['message'] ?? '',
                        style: const TextStyle(fontSize: 14),
                      );
                    }
                    return Align(
                      alignment: isSender ? Alignment.centerRight : Alignment.centerLeft,
                      child: Container(
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 174, 215, 201),
                          borderRadius: BorderRadius.only(
                            topLeft: const Radius.circular(12),
                            topRight: const Radius.circular(12),
                            bottomLeft: Radius.circular(isSender ? 12 : 0),
                            bottomRight: Radius.circular(isSender ? 0 : 12),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: isSender ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                          children: [
                            messageContent,
                            const SizedBox(height: 4),
                            Text(
                              message['dateMessageSent'] != null ? DateFormat('dd/MM/yyyy HH:mm').format((message['dateMessageSent'] as Timestamp).toDate()) : 'Sin fecha',
                              style: const TextStyle(fontSize: 10, color: Colors.grey),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              SendMessageWidget(onSendMessage: _sendMessage),
            ],
          );
        },
      ),
    );
  }
}
