import 'package:swapify/domain/entities/product.dart';

class ProductState {
  final bool isLoading;
  final List<ProductEntity>? products; 
  final List<ProductEntity>? youreProducts;
  final List<ProductEntity>? youreLikedProducts;
  final List<ProductEntity>? youreEnvolvmentProducts;
  final ProductEntity? product;
  final String? currentSortCriteria;
  final String? currentSortDirection;
  final String? currentSearchTerm;
  final double? currentMinPrice; 
  final double? currentMaxPrice;
  final bool? isFree;
  final int? currentCategoryId;
  final double? currentProximity;
  final bool? purchaseSuccess;
  final String? errorMessage;

  const ProductState({
    this.isLoading = false,
    this.products,
    this.youreProducts,
    this.youreLikedProducts,
    this.youreEnvolvmentProducts,
    this.product,
    this.currentSortCriteria,
    this.currentSortDirection,
    this.currentSearchTerm,
    this.currentMinPrice,
    this.currentMaxPrice,
    this.isFree,
    this.currentCategoryId,
    this.currentProximity,
    this.purchaseSuccess,
    this.errorMessage,
  });

  ProductState copyWith({
    bool? isLoading,
    List<ProductEntity>? products,
    final List<ProductEntity>? youreProducts,
    final List<ProductEntity>? youreLikedProducts,
    final List<ProductEntity>? youreEnvolvmentProducts,
    ProductEntity? product,
    String? currentSortCriteria,
    String? currentSortDirection,
    String? currentSearchTerm,
    double? currentMinPrice,
    double? currentMaxPrice,
    bool? isFree,
    int? currentCategoryId,
    double? currentProximity,
    bool? purchaseSuccess,
    String? errorMessage,
  }) {
    return ProductState(
      isLoading: isLoading ?? this.isLoading,
      products: products ?? this.products,
      youreProducts: youreProducts ?? this.youreProducts,
      youreLikedProducts: youreLikedProducts ?? this.youreLikedProducts,
      youreEnvolvmentProducts: youreEnvolvmentProducts ?? this.youreEnvolvmentProducts,
      product: product ?? this.product,
      currentSortCriteria: currentSortCriteria ?? this.currentSortCriteria,
      currentSortDirection: currentSortDirection ?? this.currentSortDirection,
      currentSearchTerm: currentSearchTerm ?? this.currentSearchTerm,
      currentMinPrice: currentMinPrice ?? this.currentMinPrice,
      currentMaxPrice: currentMaxPrice ?? this.currentMaxPrice,
      isFree: isFree ?? this.isFree,
      currentCategoryId: currentCategoryId ?? this.currentCategoryId,
      currentProximity: currentProximity ?? this.currentProximity,
      purchaseSuccess: purchaseSuccess ?? this.purchaseSuccess,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  factory ProductState.initial() => const ProductState();

  factory ProductState.loading() => const ProductState(isLoading: true);

  factory ProductState.success(List<ProductEntity> products) {
    return ProductState(products: products);
  }
  factory ProductState.successLikes(List<ProductEntity> youreLikedProducts) {
    return ProductState(youreLikedProducts: youreLikedProducts);
  }

  factory ProductState.successYoure(List<ProductEntity> youreProducts) {
    return ProductState(youreProducts: youreProducts);
  }

  factory ProductState.successEnvolvment(List<ProductEntity> youreEnvolvmentProducts) {
    return ProductState(youreEnvolvmentProducts: youreEnvolvmentProducts);
  }

  factory ProductState.successSingle(ProductEntity product) {
    return ProductState(product: product);
  }

  factory ProductState.failure(String errorMessage) => ProductState(errorMessage: errorMessage);
}
