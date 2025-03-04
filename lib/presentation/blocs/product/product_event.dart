import 'package:equatable/equatable.dart';
import 'package:image_picker/image_picker.dart';

abstract class ProductEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class GetProductsButtonPressed extends ProductEvent {}

class FilterProductsButtonPressed extends ProductEvent {
  final String? searchTerm;
  final double? minPrice;
  final double? maxPrice;
  final double? proximity;
  final double? userLatitude;
  final double? userLongitude;
  final int? categoryId;
  final String? criteria;
  final String? direction;

  FilterProductsButtonPressed({
    this.searchTerm,
    this.minPrice,
    this.maxPrice,
    this.proximity,
    this.userLatitude,
    this.userLongitude,
    this.categoryId,
    this.criteria,
    this.direction,
  });

  @override
  List<Object?> get props => [searchTerm, minPrice, maxPrice, proximity, userLatitude, userLongitude, categoryId, criteria, direction];
}

class GetProductButtonPressed extends ProductEvent {
  final int productId;

  GetProductButtonPressed({required this.productId});

  @override
  List<Object?> get props => [productId];
}

class GetYoureProductsButtonPressed extends ProductEvent {
  final String userId;

  GetYoureProductsButtonPressed({required this.userId});

  @override
  List<Object?> get props => [userId];
}

class GetYoureLikedProductsButtonPressed extends ProductEvent {
  final String userId;

  GetYoureLikedProductsButtonPressed({required this.userId});

  @override
  List<Object?> get props => [userId];
}

class GetYoureEnvolvmentProductsButtonPressed extends ProductEvent {
  final String userId;

  GetYoureEnvolvmentProductsButtonPressed({required this.userId});

  @override
  List<Object?> get props => [userId];
}

class DeleteProductButtonPressed extends ProductEvent {
  final int id;

  DeleteProductButtonPressed({required this.id});

  @override
  List<Object?> get props => [id];
}

class LikeProductButtonPressed extends ProductEvent {
  final String userId;
  final int productId;
  final double userLatitude;
  final double userLongitude;

  LikeProductButtonPressed({required this.userId, required this.productId, required this.userLatitude, required this.userLongitude});

  @override
  List<Object?> get props => [userId, productId];
}

class ResetFiltersButtonPressed extends ProductEvent {}

class UnlikeProductButtonPressed extends ProductEvent {
  final String userId;
  final int productId;
  final double userLatitude;
  final double userLongitude;

  UnlikeProductButtonPressed({required this.userId, required this.productId, required this.userLatitude, required this.userLongitude});

  @override
  List<Object?> get props => [userId, productId];
}

class BuyProductButtonPressed extends ProductEvent {
  final int productId;
  final String userId; 
  final String sellerId;

  BuyProductButtonPressed({required this.productId, required this.userId, required this.sellerId});

  @override
  List<Object?> get props => [productId, userId];
}

class CreateProductButtonPressed extends ProductEvent {
  final String productModel;
  final String productBrand;
  final double price;
  final String description;
  final double latitudeCreated;
  final double longitudeCreated;
  final String nameCityCreated;
  final String userId;
  final int idCategoryProduct;
  final int idStateProduct;
  final List<XFile> images;

  CreateProductButtonPressed({
    required this.productModel,
    required this.productBrand,
    required this.price,
    required this.description,
    required this.latitudeCreated,
    required this.longitudeCreated,
    required this.nameCityCreated,
    required this.userId,
    required this.idCategoryProduct,
    required this.idStateProduct,
    required this.images,
  });

  @override
  List<Object?> get props => [productModel, productBrand, price, description, latitudeCreated, longitudeCreated, nameCityCreated, userId, images];
}

class UpdateProductButtonPressed extends ProductEvent {
  final String productModel;
  final String productBrand;
  final double price;
  final String description;
  final int productId;
  final int idCategoryProduct;
  final int idStateProduct;
  final int idSaleStateProduct;
  final List<XFile> images;
  final String userId;

  UpdateProductButtonPressed({
    required this.productModel,
    required this.productBrand,
    required this.price,
    required this.description,
    required this.productId,
    required this.idCategoryProduct,
    required this.idStateProduct,
    required this.idSaleStateProduct,
    required this.images,
    required this.userId,
  });

  @override
  List<Object?> get props => [productModel, productBrand, price, description, productId, images];
}