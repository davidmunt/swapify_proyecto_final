import 'package:swapify/core/usecase.dart';
import 'package:swapify/domain/repositories/chat_repository.dart';

class SendMessageChatUsecase implements UseCase<void, SendMessageParams> {
  final ChatRepository repository;

  SendMessageChatUsecase(this.repository);

  @override
  Future<void> call(SendMessageParams params) async {
    return await repository.sendMessage(
      productOwnerId: params.productOwnerId,
      potBuyerId: params.potBuyerId,
      productId: params.productId,
      message: params.message,
      senderId: params.senderId,
      imagePath: params.imagePath,
      dateMessageSent: params.dateMessageSent,
    );
  }
}

class SendMessageParams {
  final String productOwnerId;
  final String potBuyerId;
  final int productId;
  final String senderId;
  final String? message;
  final String? imagePath;
  final DateTime dateMessageSent;

  SendMessageParams({
    required this.productOwnerId,
    required this.potBuyerId,
    required this.productId,
    required this.senderId,
    this.message,
    this.imagePath,
    required this.dateMessageSent,
  });
}
