import 'package:swapify/domain/repositories/product_repository.dart';
import 'package:swapify/core/usecase.dart';
import 'package:image_picker/image_picker.dart';

class BuyProductUseCase implements UseCase<void, BuyProductParams> {
  final ProductRepository repository;

  BuyProductUseCase(this.repository);

  @override
  Future<void> call(BuyProductParams params) async {
    return await repository.buyProduct(
      productId: params.productId,
      userId: params.userId,
    );
  }
}

class BuyProductParams {
  final int productId;
  final String userId;

  BuyProductParams({
    required this.productId,
    required this.userId,
  });
}
