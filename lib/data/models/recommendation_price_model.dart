import 'package:swapify/domain/entities/recomendation_price.dart';

class RecomendationPriceModel {
  final double recomendedPrice;

  RecomendationPriceModel({required this.recomendedPrice});

  factory RecomendationPriceModel.fromMap(Map<String, dynamic> map) {
    return RecomendationPriceModel(
      recomendedPrice: map['recomendedPrice'] as double,
    );
  }

  RecomendationPriceEntity toEntity() {
    return RecomendationPriceEntity(
      recomendationPrice: recomendedPrice,
    );
  }
}
