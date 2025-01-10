import 'package:dartz/dartz.dart';
import 'package:swapify/core/failure.dart';
import 'package:swapify/data/datasources/product_state_remote_datasource.dart';
import 'package:swapify/data/models/product_state_model.dart';
import 'package:swapify/domain/entities/product_state.dart';
import 'package:swapify/domain/repositories/product_state_repository.dart';

class ProductStateRepositoryImpl implements ProductStateRepository {
  final ProductStateDataSource dataSource;

  ProductStateRepositoryImpl(this.dataSource);

  @override
  Future<Either<Failure, List<ProductStateEntity>>> getProductState() async {
    try {
      final productStateData = await dataSource.getProductState();
      final productStateList = productStateData
          .map((state) => ProductStateModel.fromMap(state).toEntity())
          .toList();
      return Right(productStateList);
    } catch (e) {
      return Left(ServerFailure());
    }
  }
}
