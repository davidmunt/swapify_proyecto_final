import 'package:swapify/domain/entities/product_category.dart';

class ProductCategoryState {
  final bool isLoading;
  final List<ProductCategoryEntity>? productCategories;
  final String? errorMessage;

  const ProductCategoryState({
    this.isLoading = false,
    this.productCategories,
    this.errorMessage,
  });

  ProductCategoryState copyWith({
    bool? isLoading,
    List<ProductCategoryEntity>? productCategories,
    String? errorMessage,
  }) {
    return ProductCategoryState(
      isLoading: isLoading ?? this.isLoading,
      productCategories: productCategories ?? this.productCategories,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  factory ProductCategoryState.initial() => const ProductCategoryState();

  factory ProductCategoryState.loading() => const ProductCategoryState(isLoading: true);

  factory ProductCategoryState.success(List<ProductCategoryEntity> categories) {
    return ProductCategoryState(productCategories: categories);
  }

  factory ProductCategoryState.failure(String errorMessage) => ProductCategoryState(errorMessage: errorMessage);
}
