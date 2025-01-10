import 'package:dartz/dartz.dart';
import 'package:swapify/core/failure.dart';
import 'package:swapify/domain/entities/product_category.dart';

abstract class ProductCategoryRepository {
  Future<Either<Failure, List<ProductCategoryEntity>>> getProductCategory();
}
