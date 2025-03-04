import 'package:swapify/domain/entities/product.dart';
import 'package:image_picker/image_picker.dart';

class ProductModel {
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

  ProductModel({
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

  factory ProductModel.fromMap(Map<String, dynamic> map) {
    return ProductModel(
      productId: map['id_product'] as int,
      productModel: map['product_model'] as String,
      productBrand: map['product_brand'] as String,
      price: double.tryParse(map['price'].toString()) ?? 0.0,
      description: map['description'] as String,
      latitudeCreated: double.tryParse(map['latitude_created'].toString()) ?? 0.0,
      longitudeCreated: double.tryParse(map['longitude_created'].toString()) ?? 0.0,
      nameCityCreated: map['name_city_created'] as String,
      userId: map['user']['id_user'] as String,
      buyerId: map['buyer'] != null ? map['buyer']['id_user'] as String : '',
      idCategoryProduct: map['product_category']['id_category_product'] as int,
      idStateProduct: map['product_state']['id_state_product'] as int,
      idSaleStateProduct: map['product_sale_state']['id_sale_state_product'] as int,
      images: (map['images'] as List).map((img) => XFile(img['path'] as String)).toList(),
      createdAt: DateTime.parse(map['created_at'] as String),  
      lastUpdated: DateTime.parse(map['last_updated'] as String),
      likes: (map['likes'] as List).map((like) => like['user']['id_user'] as String).toList(),
      productExangedId: map['exchangedWith'] != null ? map['exchangedWith']['id_product'] as int? : null,
    );
  }

  ProductModel copyWith() {
    return ProductModel(
      productId: productId,
      productModel: productModel,
      productBrand: productBrand,
      price: price,
      description: description,
      latitudeCreated: latitudeCreated,
      longitudeCreated: longitudeCreated,
      nameCityCreated: nameCityCreated,
      userId: userId,
      buyerId: buyerId,
      idCategoryProduct: idCategoryProduct,
      idStateProduct: idStateProduct,
      idSaleStateProduct: idSaleStateProduct,
      images: images,
      createdAt: createdAt,
      lastUpdated: lastUpdated,
      likes: likes,
      productExangedId: productExangedId,
    );
  }

  ProductEntity toEntity() {
    return ProductEntity(
      productId: productId,
      productModel: productModel,
      productBrand: productBrand,
      price: price,
      description: description,
      latitudeCreated: latitudeCreated,
      longitudeCreated: longitudeCreated,
      nameCityCreated: nameCityCreated,
      userId: userId,
      buyerId: buyerId,
      idCategoryProduct: idCategoryProduct,
      idStateProduct: idStateProduct,
      idSaleStateProduct: idSaleStateProduct,
      images: images,
      createdAt: createdAt,
      lastUpdated: lastUpdated,
      likes: likes,
      productExangedId: productExangedId,
    );
  }
}