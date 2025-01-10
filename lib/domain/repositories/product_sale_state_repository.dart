import 'package:dartz/dartz.dart';
import 'package:swapify/core/failure.dart';
import 'package:swapify/domain/entities/product_sale_state.dart';

abstract class ProductSaleStateRepository {
  Future<Either<Failure, List<ProductSaleStateEntity>>> getProductSaleState();
}
