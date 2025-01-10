import 'package:swapify/domain/entities/product_state.dart';

class ProductStateModel {
  final int idStateProduct;
  final String name;

  ProductStateModel({
    required this.idStateProduct,
    required this.name,
  });

  factory ProductStateModel.fromMap(Map<String, dynamic> map) {
    return ProductStateModel(
      idStateProduct: map['id_state_product'],
      name: map['name'],
    );
  }

  ProductStateEntity toEntity() {
    return ProductStateEntity(
      idStateProduct: idStateProduct,
      name: name,
    );
  }
}