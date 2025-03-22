import 'package:swapify/domain/repositories/product_repository.dart';
import 'package:swapify/core/usecase.dart';

class ExchangeProductUseCase implements UseCase<void, ExchangeProductParams> {
  final ProductRepository repository;

  ExchangeProductUseCase(this.repository);

  @override
  Future<void> call(ExchangeProductParams params) async {
    return await repository.exchangeProduct(
      productId: params.productId,
      producExchangedtId: params.producExchangedtId,
      userId: params.userId,
      sellerId: params.sellerId,
    );
  }
}

class ExchangeProductParams {
  final int productId;
  final int producExchangedtId;
  final String userId; 
  final String sellerId;

  ExchangeProductParams({
    required this.productId,
    required this.producExchangedtId,
    required this.userId,
    required this.sellerId,
  });
}
