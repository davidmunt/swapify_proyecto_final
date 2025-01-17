import 'package:swapify/core/usecase.dart';
import 'package:swapify/domain/entities/product.dart';
import 'package:swapify/domain/repositories/product_repository.dart';

class GetProductUseCase implements UseCase<ProductEntity, GetProductParams> {
  final ProductRepository repository;
  GetProductUseCase(this.repository);

  @override
  Future<ProductEntity> call(GetProductParams params) async {
    final result = await repository.getProduct(params.productId);
    return result.fold(
      (failure) {
        throw Exception('Error al obtener el producto');
      },
      (productEntity) => productEntity,
    );
  }
}

class GetProductParams {
  final int productId;

  GetProductParams({required this.productId});
}
