import 'package:image_picker/image_picker.dart';
class ProductEntity {
  final int productId;
  final String productModel;
  final String productBrand;
  final double price;
  final String description;
  final double latitudeCreated;
  final double longitudeCreated; 
  final String nameCityCreated;
  final String userId;
  final String buyerId;
  final int idCategoryProduct;
  final int idStateProduct;
  final int idSaleStateProduct;
  final List<XFile> images; 
  final DateTime createdAt;
  final DateTime lastUpdated;
  final List<String> likes;
  final int? productExangedId;

  ProductEntity({
    required this.productId,
    required this.productModel,
    required this.productBrand,
    required this.price,
    required this.description,
    required this.latitudeCreated,
    required this.longitudeCreated,
    required this.nameCityCreated,
    required this.userId,
    required this.buyerId,
    required this.idCategoryProduct,
    required this.idStateProduct,
    required this.idSaleStateProduct,
    required this.images,
    required this.createdAt,
    required this.lastUpdated,
    required this.likes,
    this.productExangedId,
  });
}