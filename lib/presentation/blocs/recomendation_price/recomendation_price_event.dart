import 'package:equatable/equatable.dart';

abstract class RecomendationPriceEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class GetRecomendationPriceButtonPressed extends RecomendationPriceEvent {
  final String productBrand;
  final String productModel;
  final String description;
  final double price;
  final String productCategory;
  final String productState;

  GetRecomendationPriceButtonPressed({required this.productBrand, required this.productModel, required this.description, required this.price, required this.productCategory, required this.productState});

  @override
  List<Object?> get props => [productBrand, productModel, description, price, productCategory, productState];
}
