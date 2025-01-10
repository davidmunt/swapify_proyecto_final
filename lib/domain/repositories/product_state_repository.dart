import 'package:dartz/dartz.dart';
import 'package:swapify/core/failure.dart';
import 'package:swapify/domain/entities/product_state.dart';

abstract class ProductStateRepository {
  Future<Either<Failure, List<ProductStateEntity>>> getProductState();
}
