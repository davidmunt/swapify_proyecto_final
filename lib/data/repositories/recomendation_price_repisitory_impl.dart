import 'package:swapify/data/datasources/recomendation_price_remote_datasource.dart';
import 'package:swapify/domain/repositories/recomendation_price_repository.dart';

class RecomendationPriceRepositoryImpl implements RecomendationPriceRepository {
  final RecomendationPriceDataSource dataSource;

  RecomendationPriceRepositoryImpl(this.dataSource);

  @override
  Future<double?> getRecomendationProductPrice({
    required String productBrand,
    required String productModel,
    required String description,
    required double price,
    required String productCategory,
    required String productState,
  }) async {
    return await dataSource.getRecomendationProductPrice(
      productBrand: productBrand,
      productModel: productModel,
      description: description,
      price: price,
      productCategory: productCategory,
      productState: productState,
    );
  }
}
