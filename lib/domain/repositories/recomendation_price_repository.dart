abstract class RecomendationPriceRepository {
  Future<double?> getRecomendationProductPrice({
    required String productBrand,
    required String productModel,
    required String description,
    required double price,
    required String productCategory,
    required String productState,
  });
}