import 'package:swapify/domain/entities/product_sale_state.dart';

class ProductSaleStateState {
  final bool isLoading;
  final List<ProductSaleStateEntity>? productSaleStates;
  final String? errorMessage;

  const ProductSaleStateState({
    this.isLoading = false,
    this.productSaleStates,
    this.errorMessage,
  });

  ProductSaleStateState copyWith({
    bool? isLoading,
    List<ProductSaleStateEntity>? productSaleStates,
    String? errorMessage,
  }) {
    return ProductSaleStateState(
      isLoading: isLoading ?? this.isLoading,
      productSaleStates: productSaleStates ?? this.productSaleStates,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  factory ProductSaleStateState.initial() => const ProductSaleStateState();

  factory ProductSaleStateState.loading() => const ProductSaleStateState(isLoading: true);

  factory ProductSaleStateState.success(List<ProductSaleStateEntity> saleStates) {
    return ProductSaleStateState(productSaleStates: saleStates);
  }

  factory ProductSaleStateState.failure(String errorMessage) => ProductSaleStateState(errorMessage: errorMessage);
}