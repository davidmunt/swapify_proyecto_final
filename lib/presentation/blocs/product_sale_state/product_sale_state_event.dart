import 'package:equatable/equatable.dart';

abstract class ProductSaleStateEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class GetProductSaleStateButtonPressed extends ProductSaleStateEvent {}