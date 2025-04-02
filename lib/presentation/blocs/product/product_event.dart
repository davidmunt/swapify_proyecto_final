import 'package:equatable/equatable.dart';
import 'package:image_picker/image_picker.dart';

abstract class ProductEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class GetProductsButtonPressed extends ProductEvent {
  final String? userId;

  GetProductsButtonPressed({
    this.userId,
  });

  @override
  List<Object?> get props => [userId];
}

class FilterProductsButtonPressed extends ProductEvent {
  final String? searchTerm;
  final double? minPrice;
  final double? maxPrice;
  final bool? isFree;
  final double? proximity;
  final double? userLatitude;
  final double? userLongitude;
  final int? categoryId;
  final String? criteria;
  final String? direction;
  final String? userId;

  FilterProductsButtonPressed({
    this.searchTerm,
    this.minPrice,
    this.maxPrice,
    this.isFree,
    this.proximity,
    this.userLatitude,
    this.userLongitude,
    this.categoryId,
    this.criteria,
    this.direction,
    this.userId
  });

  @override
  List<Object?> get props => [searchTerm, minPrice, maxPrice, isFree, proximity, userLatitude, userLongitude, categoryId, criteria, direction, userId];
}

class GetProductButtonPressed extends ProductEvent {
  final int productId;

  GetProductButtonPressed({required this.productId});

  @override
  List<Object?> get props => [productId];
}

class GetYoureProductsButtonPressed extends ProductEvent {
  final String userId;
  final String token;

  GetYoureProductsButtonPressed({required this.userId, required this.token});

  @override
  List<Object?> get props => [userId, token];
}

class GetYoureLikedProductsButtonPressed extends ProductEvent {
  final String userId;
  final String token;

  GetYoureLikedProductsButtonPressed({required this.userId, required this.token});

  @override
  List<Object?> get props => [userId, token];
}

class GetYoureEnvolvmentProductsButtonPressed extends ProductEvent {
  final String userId;
  final String token;

  GetYoureEnvolvmentProductsButtonPressed({required this.userId, required this.token});

  @override
  List<Object?> get props => [userId, token];
}

class DeleteProductButtonPressed extends ProductEvent {
  final int id;
  final String userId;
  final String token;

  DeleteProductButtonPressed({required this.id, required this.userId, required this.token});

  @override
  List<Object?> get props => [id, userId, token];
}

class LikeProductButtonPressed extends ProductEvent {
  final String userId;
  final String token;
  final int productId;
  final double userLatitude;
  final double userLongitude;

  LikeProductButtonPressed({required this.userId, required this.productId, required this.userLatitude, required this.userLongitude, required this.token});

  @override
  List<Object?> get props => [userId, productId, token];
}

class ResetFiltersButtonPressed extends ProductEvent {
  final String userId;

  ResetFiltersButtonPressed({required this.userId});

  @override
  List<Object?> get props => [userId];
}

class UnlikeProductButtonPressed extends ProductEvent {
  final String userId;
  final int productId;
  final double userLatitude;
  final double userLongitude;
  final String token;

  UnlikeProductButtonPressed({required this.userId, required this.productId, required this.userLatitude, required this.userLongitude, required this.token});

  @override
  List<Object?> get props => [userId, productId, token];
}

class BuyProductButtonPressed extends ProductEvent {
  final int productId;
  final String userId; 
  final String sellerId;
  final String token;

  BuyProductButtonPressed({required this.productId, required this.userId, required this.sellerId, required this.token});

  @override
  List<Object?> get props => [productId, userId, token];
}

class ExchangeProductButtonPressed extends ProductEvent {
  final int productId;
  final int producExchangedtId;
  final String userId; 
  final String sellerId;
  final String token;

  ExchangeProductButtonPressed({required this.productId, required this.userId, required this.sellerId, required this.producExchangedtId, required this.token});

  @override
  List<Object?> get props => [productId, producExchangedtId, userId, sellerId, token];
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
  final String token;

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
    required this.token
  });

  @override
  List<Object?> get props => [productModel, productBrand, price, description, latitudeCreated, longitudeCreated, nameCityCreated, userId, images, token];
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
  final String token;

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
    required this.token
  });

  @override
  List<Object?> get props => [productModel, productBrand, price, description, productId, images, token];
}