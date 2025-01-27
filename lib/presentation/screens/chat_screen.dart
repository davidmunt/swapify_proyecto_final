import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart';
import 'package:swapify/presentation/blocs/chat/chat_bloc.dart';
import 'package:swapify/presentation/blocs/chat/chat_event.dart';
import 'package:swapify/presentation/blocs/user/user_bloc.dart';
import 'package:swapify/presentation/blocs/user/user_state.dart';
import 'package:swapify/presentation/widgets/alertdialog_show_image_chat.dart';

class ChatScreen extends StatefulWidget {
  final String productOwnerId;
  final String potBuyerId;
  final int productId;
  final TextEditingController mensaje = TextEditingController();

  ChatScreen({
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
  XFile? selectedImage;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    chatId = "${widget.productOwnerId}${widget.potBuyerId}${widget.productId}";
  }

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        selectedImage = image;
      });
    }
  }

  void _sendMessage(String userId) {
    if (widget.mensaje.text.isNotEmpty && selectedImage == null) {
      context.read<ChatBloc>().add(
        SendMessageButtonPressed(
          productOwnerId: widget.productOwnerId,
          potBuyerId: widget.potBuyerId,
          productId: widget.productId,
          message: widget.mensaje.text,
          image: null,
          senderId: userId,
          dateMessageSent: DateTime.now(),
        ),
      );
      widget.mensaje.clear();
    } else if (selectedImage != null && widget.mensaje.text.isEmpty) {
      context.read<ChatBloc>().add(
        SendMessageButtonPressed(
          productOwnerId: widget.productOwnerId,
          potBuyerId: widget.potBuyerId,
          productId: widget.productId,
          message: null,
          image: selectedImage,
          senderId: userId,
          dateMessageSent: DateTime.now(),
        ),
      );
      setState(() {
        selectedImage = null;
      });
    }
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Chat"),
      ),
      body: BlocBuilder<UserBloc, UserState>(
        builder: (context, userState) {
          if (userState.isLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (userState.user != null) {
            final userId = userState.user!.id;
            return StreamBuilder<DocumentSnapshot>(
              stream: FirebaseFirestore.instance.collection('chats').doc(chatId).snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (!snapshot.hasData || !snapshot.data!.exists) {
                  return Center(child: Text(AppLocalizations.of(context)!.errorObtainingChat));
                }
                final chatData = snapshot.data!.data() as Map<String, dynamic>;
                final messages = List<Map<String, dynamic>>.from(chatData['messages'] ?? []);
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  if (_scrollController.hasClients) {
                    _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
                  }
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
                                errorBuilder: (context, error, stackTrace) {
                                  return const Icon(Icons.image_not_supported, size: 50);
                                },
                              ),
                            );
                          } else {
                            messageContent = Text(message['message'] ?? '', style: const TextStyle(fontSize: 14));
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
                                    message['dateMessageSent'] != null ? DateFormat('dd/MM/yyyy HH:mm').format(
                                      (message['dateMessageSent'] as Timestamp).toDate()) : 'Sin fecha',
                                    style: const TextStyle(fontSize: 10, color: Colors.grey),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    if (selectedImage != null)
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            Image.file(
                              File(selectedImage!.path),
                              width: 50,
                              height: 50,
                            ),
                            const SizedBox(width: 8),
                            IconButton(
                              icon: const Icon(Icons.close),
                              onPressed: () {
                                setState(() {
                                  selectedImage = null;
                                });
                              },
                            )
                          ],
                        ),
                      ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: widget.mensaje,
                              decoration: InputDecoration(
                                hintText: AppLocalizations.of(context)!.sendAMessage,
                                border: const OutlineInputBorder(),
                              ),
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.image),
                            onPressed: _pickImage,
                          ),
                          IconButton(
                            icon: const Icon(Icons.send),
                            onPressed: () => _sendMessage(userId),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              },
            );
          } else {
            return Center(child: Text(AppLocalizations.of(context)!.errorObtainingUserInfoChat));
          }
        },
      ),
    );
  }
}