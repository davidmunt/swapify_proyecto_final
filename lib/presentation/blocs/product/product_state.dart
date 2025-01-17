import 'package:swapify/domain/entities/product.dart';

class ProductState {
  final bool isLoading;
  final List<ProductEntity>? products;
  final ProductEntity? product;
  final List<ProductEntity>? filteredProducts;
  final List<ProductEntity>? sortedProducts;
  final bool? purchaseSuccess;
  final String? errorMessage;

  const ProductState({
    this.isLoading = false,
    this.products,
    this.product,
    this.filteredProducts,
    this.purchaseSuccess,
    this.sortedProducts,
    this.errorMessage,
  });

  ProductState copyWith({
    bool? isLoading,
    List<ProductEntity>? products,
    ProductEntity? product,
    List<ProductEntity>? filteredProducts,
    List<ProductEntity>? sortedProducts,
    bool? purchaseSuccess,
    String? errorMessage,
  }) {
    return ProductState(
      isLoading: isLoading ?? this.isLoading,
      products: products ?? this.products,
      product: product ?? this.product,
      filteredProducts: filteredProducts ?? this.filteredProducts,
      sortedProducts: sortedProducts ?? this.sortedProducts,
      purchaseSuccess: purchaseSuccess ?? this.purchaseSuccess,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  factory ProductState.initial() => const ProductState();

  factory ProductState.loading() => const ProductState(isLoading: true);

  factory ProductState.success(List<ProductEntity> products) {
    return ProductState(products: products);
  }

  factory ProductState.successSingle(ProductEntity product) {
    return ProductState(product: product);
  }

  factory ProductState.failure(String errorMessage) => ProductState(errorMessage: errorMessage);
}
