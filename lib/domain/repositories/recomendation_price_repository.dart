import 'package:dartz/dartz.dart';
import 'package:swapify/core/failure.dart';

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