import 'package:swapify/core/usecase.dart';
import 'package:swapify/domain/entities/recomendation_price.dart';
import 'package:swapify/domain/repositories/recomendation_price_repository.dart';

class GetRecomendationPriceUseCase implements UseCase<RecomendationPriceEntity?, GetRecomendationPriceParams> {
  final RecomendationPriceRepository repository;

  GetRecomendationPriceUseCase(this.repository);

  @override
  Future<RecomendationPriceEntity?> call(GetRecomendationPriceParams params) async {
    final result = await repository.getRecomendationProductPrice(
      productBrand: params.productBrand,
      productModel: params.productModel,
      description: params.description,
      price: params.price,
      productCategory: params.productCategory,
      productState: params.productState,
    );
    if (result == null) {
      return null;
    }
    return RecomendationPriceEntity(recomendationPrice: result);
  }
}

class GetRecomendationPriceParams {
  final String productBrand;
  final String productModel;
  final String description;
  final double price;
  final String productCategory;
  final String productState;

  GetRecomendationPriceParams({
    required this.productBrand,
    required this.productModel,
    required this.description,
    required this.price,
    required this.productCategory,
    required this.productState,
  });
}
