import 'package:swapify/core/usecase.dart';
import 'package:swapify/domain/entities/product.dart';
import 'package:swapify/domain/repositories/product_repository.dart';

class GetFilteredProductsUseCase implements UseCase<List<ProductEntity>, GetFilteredProductsParams> {
  final ProductRepository repository;

  GetFilteredProductsUseCase(this.repository);

  @override
  Future<List<ProductEntity>> call(GetFilteredProductsParams params) async {
    final result = await repository.getFilteredProducts(filters: params.filters);
    return result.fold(
      (failure) => throw Exception('Error al obtener los productos filtrados'),
      (products) => products,
    );
  }
}

class GetFilteredProductsParams {
  final Map<String, dynamic>? filters;

  GetFilteredProductsParams({this.filters});
}
