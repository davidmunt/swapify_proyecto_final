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
  final int idCategoryProduct;
  final int idStateProduct;
  final List<XFile> images;
  final DateTime createdAt;
  final List<String> likes;

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
    required this.idCategoryProduct,
    required this.idStateProduct,
    required this.images,
    required this.createdAt,
    required this.likes,
  });
}