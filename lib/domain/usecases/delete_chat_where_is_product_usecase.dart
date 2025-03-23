import 'package:swapify/core/usecase.dart';
import 'package:swapify/domain/repositories/chat_repository.dart';

class DeleteChatWhereIsProductUsecase implements UseCase<void, DeleteChatWhereIsProductParams> {
  final ChatRepository repository;

  DeleteChatWhereIsProductUsecase(this.repository);

  @override
  Future<void> call(DeleteChatWhereIsProductParams params) async {
    return await repository.deleteChatAndExchangeProposal(
      productId: params.productId,
    );
  }
}

class DeleteChatWhereIsProductParams {
  final int productId;

  DeleteChatWhereIsProductParams({
    required this.productId,
  });
}
