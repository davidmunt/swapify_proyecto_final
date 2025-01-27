import 'package:equatable/equatable.dart';
import 'package:image_picker/image_picker.dart';

abstract class ChatEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class SendMessageButtonPressed extends ChatEvent {
  final String productOwnerId;
  final String potBuyerId;
  final int productId;
  final String? message;
  final XFile? image;
  final String senderId;
  final DateTime dateMessageSent;

  SendMessageButtonPressed({
    required this.productOwnerId,
    required this.potBuyerId,
    required this.productId,
    this.message,
    this.image,
    required this.senderId,
    required this.dateMessageSent,
  });

  @override
  List<Object?> get props => [productOwnerId, potBuyerId, productId, message, image, senderId, dateMessageSent];
}

class GetMyChatsButtonPressed extends ChatEvent {
  final String userId;

  GetMyChatsButtonPressed({required this.userId});

  @override
  List<Object?> get props => [userId];
}

class UploadMessageImageButtonPressed extends ChatEvent {
  final XFile image;

  UploadMessageImageButtonPressed({required this.image});

  @override
  List<Object?> get props => [image];
}

class GetChatButtonPressed extends ChatEvent {
  final String chatId;

  GetChatButtonPressed({required this.chatId});

  @override
  List<Object?> get props => [chatId];
}

class ResetChatStateEvent extends ChatEvent {}
