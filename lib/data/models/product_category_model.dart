import 'package:swapify/domain/entities/product_category.dart';

class ProductCategoryModel {
  final int idCategoryProduct;
  final String name;
  final String description;

  ProductCategoryModel({
    required this.idCategoryProduct,
    required this.name,
    required this.description,
  });

  factory ProductCategoryModel.fromMap(Map<String, dynamic> map) {
    return ProductCategoryModel(
      idCategoryProduct: map['id_category_product'],
      name: map['name'],
      description: map['description'],
    );
  }

  ProductCategoryEntity toEntity() {
    return ProductCategoryEntity(
      idCategoryProduct: idCategoryProduct,
      name: name,
      description: description,
    );
  }
}