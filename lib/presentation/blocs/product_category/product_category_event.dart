import 'package:equatable/equatable.dart';

abstract class ProductCategoryEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class GetProductCategoryButtonPressed extends ProductCategoryEvent {}