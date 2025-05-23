import 'package:dartz/dartz.dart';
import 'package:swapify/core/failure.dart';
import 'package:swapify/domain/entities/product.dart';
import 'package:image_picker/image_picker.dart';

abstract class ProductRepository {
  Future<Either<Failure, List<ProductEntity>>> getProducts();
  Future<Either<Failure, List<ProductEntity>>> getYoureLikedProducts(String userId, String token);
  Future<Either<Failure, List<ProductEntity>>> getYoureEnvolvmentProducts(String userId, String token);
  Future<Either<Failure, List<ProductEntity>>> getYoureProducts(String userId, String token);
  Future<Either<Failure, ProductEntity>> getProduct(int productId);
  Future<Either<Failure, void>> deleteProduct(int id, String token);
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
    required String token,
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
    required int idSaleStateProduct,
    required int productId,
    required String token,
  });
  Future<void> updateProductImages({
    required int productId,
    required List<XFile> images,
  });
  Future<void> buyProduct({
    required int productId,
    required String userId, 
    required String sellerId,
    required String token,
  });
  Future<void> exchangeProduct({
    required int productId,
    required int producExchangedtId,
    required String userId, 
    required String sellerId,
    required String token,
  });
  Future<Either<Failure, List<ProductEntity>>> getFilteredProducts({Map<String, dynamic>? filters});
  Future<Either<Failure, void>> likeProduct({required int productId, required String userId, required String token,});
  Future<Either<Failure, void>> unlikeProduct({required int productId, required String userId, required String token,});  
}