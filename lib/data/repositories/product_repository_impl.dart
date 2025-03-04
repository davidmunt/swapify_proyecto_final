import 'package:dartz/dartz.dart';
import 'package:swapify/core/failure.dart';
import 'package:swapify/domain/entities/product.dart';
import 'package:swapify/domain/repositories/product_repository.dart';
import 'package:swapify/data/datasources/product_remote_datasource.dart';
import 'package:image_picker/image_picker.dart';

class ProductRepositoryImpl implements ProductRepository {
  final ProductDataSource dataSource;

  ProductRepositoryImpl(this.dataSource);

  @override
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
  }) async {
    return await dataSource.createProduct(
      productModel: productModel,
      productBrand: productBrand,
      price: price,
      description: description,
      latitudeCreated: latitudeCreated,
      longitudeCreated: longitudeCreated,
      nameCityCreated: nameCityCreated,
      userId: userId,
      idCategoryProduct: idCategoryProduct,
      idStateProduct: idStateProduct,
    );
  }

  @override
  Future<void> uploadProductImages({
    required int productId,
    required List<XFile> images,
  }) async {
    return await dataSource.uploadProductImages(
      productId: productId,
      images: images,
    );
  }

  @override
  Future<void> updateProduct({
    required String productModel,
    required String productBrand,
    required double price,
    required String description,
    required int idCategoryProduct,
    required int idStateProduct,
    required int idSaleStateProduct,
    required int productId,
  }) async {
    return await dataSource.updateProduct(
      productModel: productModel,
      productBrand: productBrand,
      price: price,
      description: description,
      productId: productId,
      idCategoryProduct: idCategoryProduct,
      idStateProduct: idStateProduct,
      idSaleStateProduct: idSaleStateProduct,
    );
  }

  @override
  Future<void> updateProductImages({
    required int productId,
    required List<XFile> images,
  }) async {
    return await dataSource.updateProductImages(
      productId: productId,
      images: images,
    );
  }

  @override
  Future<void> buyProduct({
    required int productId,
    required String userId, 
    required String sellerId,
  }) async {
    try {
      await dataSource.buyProduct(productId: productId, userId: userId, sellerId: sellerId);
      return;
    } catch (e) {
      throw ServerFailure();
    }
  }

  @override
  Future<Either<Failure, void>> deleteProduct(int id) async {
    try {
      await dataSource.deleteProduct(id);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, void>> likeProduct({required int productId, required String userId}) async {
    try {
      await dataSource.likeProduct(productId: productId, userId: userId);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, void>> unlikeProduct({required int productId, required String userId}) async {
    try {
      await dataSource.unlikeProduct(productId: productId, userId: userId);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, List<ProductEntity>>> getProducts() async {
    try {
      final productModels = await dataSource.getProducts();
      final productEntities = productModels.map((model) => model.toEntity()).toList();
      return Right(productEntities);
    } catch (e) {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, List<ProductEntity>>> getYoureLikedProducts(String userId) async {
    try {
      final productModels = await dataSource.getYoureLikedProducts(userId);
      final productEntities = productModels.map((model) => model.toEntity()).toList();
      return Right(productEntities);
    } catch (e) {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, List<ProductEntity>>> getYoureEnvolvmentProducts(String userId) async {
    try {
      final productModels = await dataSource.getYoureEnvolvmentProducts(userId);
      final productEntities = productModels.map((model) => model.toEntity()).toList();
      return Right(productEntities);
    } catch (e) {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, List<ProductEntity>>> getYoureProducts(String userId) async {
    try {
      final productModels = await dataSource.getYoureProducts(userId);
      final productEntities = productModels.map((model) => model.toEntity()).toList();
      return Right(productEntities);
    } catch (e) {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, List<ProductEntity>>> getFilteredProducts({Map<String, dynamic>? filters}) async {
    try {
      final productModels = await dataSource.getFilteredProducts(filters: filters);
      final productEntities = productModels.map((product) => product.toEntity()).toList();
      return Right(productEntities);
    } catch (e) {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, ProductEntity>> getProduct(int productId) async {
    try {
      final productModel = await dataSource.getProduct(productId);
      return Right(productModel.toEntity());
    } catch (e) {
      return Left(ServerFailure());
    }
  }
}