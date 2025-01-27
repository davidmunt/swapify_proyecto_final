import 'package:swapify/core/usecase.dart';
import 'package:swapify/domain/repositories/product_repository.dart';

class CreateProductUseCase implements UseCase<int, CreateProductParams> {
  final ProductRepository repository;

  CreateProductUseCase(this.repository);

  @override
  Future<int> call(CreateProductParams params) async {
    return await repository.createProduct(
      productModel: params.productModel,
      productBrand: params.productBrand,
      price: params.price,
      description: params.description,
      latitudeCreated: params.latitudeCreated,
      longitudeCreated: params.longitudeCreated,
      nameCityCreated: params.nameCityCreated,
      userId: params.userId,
      idCategoryProduct: params.idCategoryProduct,
      idStateProduct: params.idStateProduct,
    );
  }
}

class CreateProductParams {
  final String productModel;
  final String productBrand;
  final double price;
  final String description;
  final double latitudeCreated;
  final double longitudeCreated;
  final String nameCityCreated;
  final String userId;
  final int idCategoryProduct;
  final int idStateProduct;

  CreateProductParams({
    required this.productModel,
    required this.productBrand,
    required this.price,
    required this.description,
    required this.latitudeCreated,
    required this.longitudeCreated,
    required this.nameCityCreated,
    required this.userId,
    required this.idCategoryProduct,
    required this.idStateProduct,
  });
}
