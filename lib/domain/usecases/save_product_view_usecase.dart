import 'package:swapify/core/usecase.dart';
import 'package:swapify/domain/repositories/product_view_repository.dart';

class SaveProductViewUsecase implements UseCase<void, SaveProductViewParams> {
  final ProductViewRepository repository;

  SaveProductViewUsecase(this.repository);

  @override
  Future<void> call(SaveProductViewParams params) async {
    await repository.saveProductView(
      userId: params.userId,
      productId: params.productId,
      token: params.token,
    );
  }
}

class SaveProductViewParams {
  final String userId;
  final int productId;
  final String token;

  SaveProductViewParams({
    required this.userId,
    required this.productId,
    required this.token
  });
}
