import 'package:swapify/core/usecase.dart';
import 'package:swapify/domain/entities/product.dart';
import 'package:swapify/domain/repositories/product_repository.dart';

class GetProductsUseCase implements UseCase<List<ProductEntity>, NoParams> {
  final ProductRepository repository;
  GetProductsUseCase(this.repository);

  @override
  Future<List<ProductEntity>> call(NoParams params) async {
    final result = await repository.getProducts();
    return result.fold(
      (failure) {
        throw Exception('Error al obtener los productos');
      },
      (productEntities) => productEntities,
    );
  }
}

class GetProductsParams {

  GetProductsParams();
}