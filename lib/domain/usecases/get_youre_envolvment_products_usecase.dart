import 'package:swapify/core/usecase.dart';
import 'package:swapify/domain/entities/product.dart';
import 'package:swapify/domain/repositories/product_repository.dart';

class GetYoureEnvolvmentProductsUseCase implements UseCase<List<ProductEntity>, GetYoureEnvolvmentProductsParams> {
  final ProductRepository repository;
  GetYoureEnvolvmentProductsUseCase(this.repository);

  @override
  Future<List<ProductEntity>> call(GetYoureEnvolvmentProductsParams params) async {
    final result = await repository.getYoureEnvolvmentProducts(params.userId, params.token);
    return result.fold(
      (failure) {
        throw Exception('Error al obtener tus productos favoritos');
      },
      (productEntities) => productEntities,
    );
  }
}

class GetYoureEnvolvmentProductsParams {
  final String userId;
  final String token;

  GetYoureEnvolvmentProductsParams({required this.userId, required this.token});
}