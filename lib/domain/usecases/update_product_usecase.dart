import 'package:swapify/core/usecase.dart';
import 'package:swapify/domain/repositories/product_repository.dart';

class UpdateProductUseCase implements UseCase<void, UpdateProductParams> {
  final ProductRepository repository;

  UpdateProductUseCase(this.repository);

  @override
  Future<void> call(UpdateProductParams params) async {
    return await repository.updateProduct(
      productModel: params.productModel,
      productBrand: params.productBrand,
      price: params.price,
      description: params.description,
      productId: params.productId,
      idCategoryProduct: params.idCategoryProduct,
      idStateProduct: params.idStateProduct,
      idSaleStateProduct: params.idSaleStateProduct,
      token: params.token
    );
  }
}

class UpdateProductParams {
  final String productModel;
  final String productBrand;
  final double price;
  final String description;
  final int productId;
  final int idCategoryProduct;
  final int idStateProduct;
  final int idSaleStateProduct;
  final String token;

  UpdateProductParams({
    required this.productModel,
    required this.productBrand,
    required this.price,
    required this.description,
    required this.productId,
    required this.idCategoryProduct,
    required this.idStateProduct,
    required this.idSaleStateProduct,
    required this.token,
  });
}
