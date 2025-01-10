import 'package:swapify/core/usecase.dart';
import 'package:swapify/domain/entities/product_category.dart';
import 'package:swapify/domain/repositories/product_category_repository.dart';

class GetProductCategoryUseCase implements UseCase<List<ProductCategoryEntity>, GetProductCategoryParams> {
  final ProductCategoryRepository repository;

  GetProductCategoryUseCase(this.repository);

  @override
  Future<List<ProductCategoryEntity>> call(GetProductCategoryParams params) async {
    final result = await repository.getProductCategory();
    return result.fold(
      (failure) => throw Exception('Error al obtener las categorias: $failure'),
      (categories) => categories,
    );
  }
}

class GetProductCategoryParams {}
