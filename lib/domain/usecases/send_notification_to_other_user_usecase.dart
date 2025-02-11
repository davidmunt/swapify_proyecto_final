import 'package:dartz/dartz.dart';
import 'package:swapify/core/failure.dart';
import 'package:swapify/core/usecase.dart';
import 'package:swapify/domain/repositories/chat_repository.dart';

class SendNotificationToOtherUserUseCase implements UseCase<void, SendNotificationToOtherUserParams> {
  final ChatRepository repository;

  SendNotificationToOtherUserUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(SendNotificationToOtherUserParams params) {
    return repository.sendNotificationToOtherUser(
      productId: params.productId,
      text: params.text,
      sender: params.sender,
      reciver: params.reciver,
    );
  }
}

class SendNotificationToOtherUserParams {
  final int productId;
  final String? text;
  final String sender;
  final String reciver;

  SendNotificationToOtherUserParams({
    required this.productId,
    required this.text,
    required this.sender,
    required this.reciver,
  });
}
