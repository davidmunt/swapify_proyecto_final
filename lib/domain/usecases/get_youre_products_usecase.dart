import 'package:swapify/core/usecase.dart';
import 'package:swapify/domain/entities/product.dart';
import 'package:swapify/domain/repositories/product_repository.dart';

class GetYoureProductsUseCase implements UseCase<List<ProductEntity>, GetYoureProductsParams> {
  final ProductRepository repository;
  GetYoureProductsUseCase(this.repository);

  @override
  Future<List<ProductEntity>> call(GetYoureProductsParams params) async {
    final result = await repository.getYoureProducts(params.userId);
    return result.fold(
      (failure) {
        throw Exception('Error al obtener tus productos');
      },
      (productEntities) => productEntities,
    );
  }
}

class GetYoureProductsParams {
  final String userId;

  GetYoureProductsParams({required this.userId});
}