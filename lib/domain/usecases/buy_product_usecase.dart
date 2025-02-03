import 'package:swapify/domain/repositories/product_repository.dart';
import 'package:swapify/core/usecase.dart';

class BuyProductUseCase implements UseCase<void, BuyProductParams> {
  final ProductRepository repository;

  BuyProductUseCase(this.repository);

  @override
  Future<void> call(BuyProductParams params) async {
    return await repository.buyProduct(
      productId: params.productId,
      userId: params.userId,
      sellerId: params.sellerId,
    );
  }
}

class BuyProductParams {
  final int productId;
  final String userId; 
  final String sellerId;

  BuyProductParams({
    required this.productId,
    required this.userId,
    required this.sellerId,
  });
}
