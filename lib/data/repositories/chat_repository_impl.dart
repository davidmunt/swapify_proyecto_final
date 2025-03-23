import 'package:dartz/dartz.dart';
import 'package:swapify/core/failure.dart';
import 'package:image_picker/image_picker.dart';
import 'package:swapify/data/datasources/chat_remote_datasource.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:swapify/data/models/chat_model.dart';
import 'package:swapify/domain/entities/chat.dart';
import 'package:swapify/domain/repositories/chat_repository.dart';

class ChatRepositoryImpl implements ChatRepository {
  final ChatDataSource dataSource;
  final SharedPreferences prefs;

  ChatRepositoryImpl(this.dataSource, this.prefs);

  @override
  Future<Either<Failure, List<ChatEntity>>> getMyChats(String userId) async {
    try {
      final chatModels = await dataSource.getMyChats(userId: userId);
      final chatEntities = chatModels.map((chat) => ChatModel.fromFirestore(chat).toEntity()).toList();
      return Right(chatEntities);
    } catch (e) {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, Map<String, dynamic>?>> getChat(String chatId) async {
    try {
      final chat = await dataSource.getChat(chatId);
      return Right(chat);
    } catch (e) {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, void>> sendMessage({
    required String productOwnerId,
    required String potBuyerId,
    required String senderId,
    required int productId,
    String? message,
    String? imagePath,
    int? idProduct, 
    String? productImage,
    required DateTime dateMessageSent,
  }) async {
    try {
      await dataSource.sendMessage(
        productOwnerId: productOwnerId,
        potBuyerId: potBuyerId,
        productId: productId,
        message: message,
        senderId: senderId,
        imagePath: imagePath,
        idProduct: idProduct,
        productImage: productImage,
        dateMessageSent: dateMessageSent,
      );
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, void>> updateExchangeStatus({
    required String productOwnerId,
    required String potBuyerId,
    required int productId,
    required int idProduct,
    required bool accepted,
  }) async {
    try {
      await dataSource.updateExchangeStatus(
        productOwnerId: productOwnerId,
        potBuyerId: potBuyerId,
        productId: productId,
        idProduct: idProduct,
        accepted: accepted,
      );
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure());
    }
  }

 @override
  Future<Either<Failure, String>> uploadMessageImage({
    required XFile image,
  }) async {
    try {
      final path = await dataSource.uploadMessageImage(image: image);
      return Right(path);
    } catch (e) {
      return Left(ServerFailure());
    }
  }

  @override
  Future<void> deleteChatAndExchangeProposal({
    required int productId,
  }) async {
    try {
      await dataSource.deleteChatAndExchangeProposal(productId: productId);
    } catch (e) {
      throw Exception('Error al eliminar el chat y la propuesta de intercambio: $e');
    }
  }

  @override
  Future<Either<Failure, void>> sendNotificationToOtherUser({
    required int productId,
    required String? text,
    required String sender,
    required String reciver,
  }) async {
    try {
      await dataSource.sendNotificationToOtherUser(
        productId: productId,
        text: text,
        sender: sender,
        reciver: reciver,
      );
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure());
    }
  }
}
