import 'package:swapify/domain/entities/chat.dart';

class ChatState {
  final bool isLoading;
  final List<ChatEntity>? chats;
  final ChatEntity? chat;
  final bool? purchaseSuccess;
  final String? errorMessage;

  const ChatState({
    this.isLoading = false,
    this.chats,
    this.chat,
    this.purchaseSuccess,
    this.errorMessage,
  });

  ChatState copyWith({
    bool? isLoading,
    List<ChatEntity>? chats,
    ChatEntity? chat,
    bool? purchaseSuccess,
    String? errorMessage,
  }) {
    return ChatState(
      isLoading: isLoading ?? this.isLoading,
      chats: chats ?? this.chats,
      chat: chat ?? this.chat,
      purchaseSuccess: purchaseSuccess ?? this.purchaseSuccess,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  factory ChatState.initial() => const ChatState();

  factory ChatState.loading() => const ChatState(isLoading: true);

  factory ChatState.success(List<ChatEntity> chats) {
    return ChatState(chats: chats);
  }

  factory ChatState.successSingle(ChatEntity chat) {
    return ChatState(chat: chat);
  }

  factory ChatState.failure(String errorMessage) => ChatState(errorMessage: errorMessage);
}
