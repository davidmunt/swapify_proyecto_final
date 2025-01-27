import 'package:image_picker/image_picker.dart';
import 'package:swapify/core/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:swapify/domain/entities/chat.dart';

abstract class ChatRepository {
  Future<Either<Failure, List<ChatEntity>>> getMyChats(String userId);
  Future<Either<Failure, Map<String, dynamic>?>> getChat(String chatId);
  Future<void> sendMessage({
    required String productOwnerId,
    required String potBuyerId,
    required int productId,
    required String senderId,
    String? message,
    String? imagePath,
    required DateTime dateMessageSent,
  });
  Future<Either<Failure, String>> uploadMessageImage({
    required XFile image,
  });
}
