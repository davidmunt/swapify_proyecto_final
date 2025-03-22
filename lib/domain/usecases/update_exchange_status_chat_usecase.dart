import 'package:dartz/dartz.dart';
import 'package:swapify/core/failure.dart';
import 'package:swapify/core/usecase.dart';
import 'package:swapify/domain/repositories/chat_repository.dart';

class UpdateExchangeStatusChatUseCase implements UseCase<void, UpdateExchangeStatusChatParams> {
  final ChatRepository repository;

  UpdateExchangeStatusChatUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(UpdateExchangeStatusChatParams params) {
    return repository.updateExchangeStatus(
      productOwnerId: params.productOwnerId,
      potBuyerId: params.potBuyerId,
      productId: params.productId,
      idProduct: params.idProduct,
      accepted: params.accepted,
    );
  }
}

class UpdateExchangeStatusChatParams {
  final String productOwnerId;
  final String potBuyerId;
  final int productId;
  final int idProduct;
  final bool accepted;

  UpdateExchangeStatusChatParams({
    required this.productOwnerId,
    required this.potBuyerId,
    required this.productId,
    required this.idProduct,
    required this.accepted,
  });
}
