import 'package:swapify/domain/entities/product_sale_state.dart';

class ProductSaleStateModel {
  final int idSaleStateProduct;
  final String name;

  ProductSaleStateModel({
    required this.idSaleStateProduct,
    required this.name,
  });

  factory ProductSaleStateModel.fromMap(Map<String, dynamic> map) {
    return ProductSaleStateModel(
      idSaleStateProduct: map['id_sale_state_product'],
      name: map['name'],
    );
  }

  ProductSaleStateEntity toEntity() {
    return ProductSaleStateEntity(
      idSaleStateProduct: idSaleStateProduct,
      name: name,
    );
  }
}