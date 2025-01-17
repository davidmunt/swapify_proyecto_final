import 'package:dartz/dartz.dart';
import 'package:swapify/core/failure.dart';
import 'package:swapify/domain/entities/product.dart';
import 'package:image_picker/image_picker.dart';

abstract class ProductRepository {
  Future<Either<Failure, List<ProductEntity>>> getProducts();
  Future<Either<Failure, ProductEntity>> getProduct(int productId);
  Future<Either<Failure, void>> deleteProduct(int id);
  Future<int> createProduct({
    required String productModel,
    required String productBrand,
    required double price,
    required String description,
    required double latitudeCreated,
    required double longitudeCreated,
    required String nameCityCreated,
    required String userId,
    required int idCategoryProduct,
    required int idStateProduct,
  });
  Future<void> uploadProductImages({
    required int productId,
    required List<XFile> images,
  });
  Future<void> updateProduct({
    required String productModel,
    required String productBrand,
    required double price,
    required String description,
    required int idCategoryProduct,
    required int idStateProduct,
    required int productId,
  });
  Future<void> updateProductImages({
    required int productId,
    required List<XFile> images,
  });
  Future<void> buyProduct({
    required int productId,
    required String userId,
  });
  Future<Either<Failure, void>> likeProduct({required int productId, required String userId});
  Future<Either<Failure, void>> unlikeProduct({required int productId, required String userId});  
}