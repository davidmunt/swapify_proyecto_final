import 'package:dartz/dartz.dart';
import 'package:swapify/core/failure.dart';
import 'package:swapify/data/datasources/product_category_remote_datasource.dart';
import 'package:swapify/data/models/product_category_model.dart';
import 'package:swapify/domain/entities/product_category.dart';
import 'package:swapify/domain/repositories/product_category_repository.dart';

class ProductCategoryRepositoryImpl implements ProductCategoryRepository {
  final ProductCategoryDataSource dataSource;

  ProductCategoryRepositoryImpl(this.dataSource);

  @override
  Future<Either<Failure, List<ProductCategoryEntity>>> getProductCategory() async {
    try {
      final productCategoryData = await dataSource.getProductCategory();
      final productCategoryList = productCategoryData
          .map((category) => ProductCategoryModel.fromMap(category).toEntity())
          .toList();
      return Right(productCategoryList);
    } catch (e) {
      return Left(ServerFailure());
    }
  }
}
