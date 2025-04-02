import 'package:swapify/core/usecase.dart';
import 'package:swapify/domain/entities/product.dart';
import 'package:swapify/domain/repositories/product_repository.dart';

class GetYoureLikedProductsUseCase implements UseCase<List<ProductEntity>, GetYoureLikedProductsParams> {
  final ProductRepository repository;
  GetYoureLikedProductsUseCase(this.repository);

  @override
  Future<List<ProductEntity>> call(GetYoureLikedProductsParams params) async {
    final result = await repository.getYoureLikedProducts(params.userId, params.token);
    return result.fold(
      (failure) {
        throw Exception('Error al obtener tus productos favoritos');
      },
      (productEntities) => productEntities,
    );
  }
}

class GetYoureLikedProductsParams {
  final String userId;
  final String token;

  GetYoureLikedProductsParams({required this.userId, required this.token});
}