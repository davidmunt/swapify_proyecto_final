import 'package:dartz/dartz.dart';
import 'package:swapify/core/failure.dart';
import 'package:swapify/data/datasources/product_sale_state_remote_datasource.dart';
import 'package:swapify/data/models/product_sale_state_model.dart';
import 'package:swapify/domain/entities/product_sale_state.dart';
import 'package:swapify/domain/repositories/product_sale_state_repository.dart';

class ProductSaleStateRepositoryImpl implements ProductSaleStateRepository {
  final ProductSaleStateDataSource dataSource;

  ProductSaleStateRepositoryImpl(this.dataSource);

  @override
  Future<Either<Failure, List<ProductSaleStateEntity>>> getProductSaleState() async {
    try {
      final productSaleStateData = await dataSource.getProductSaleState();
      final productSaleStateList = productSaleStateData
          .map((saleState) => ProductSaleStateModel.fromMap(saleState).toEntity())
          .toList();
      return Right(productSaleStateList);
    } catch (e) {
      return Left(ServerFailure());
    }
  }
}