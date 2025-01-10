import 'package:swapify/domain/entities/product_state.dart';

class ProductStateState {
  final bool isLoading;
  final List<ProductStateEntity>? productStates;
  final String? errorMessage;

  const ProductStateState({
    this.isLoading = false,
    this.productStates,
    this.errorMessage,
  });

  ProductStateState copyWith({
    bool? isLoading,
    List<ProductStateEntity>? productStates,
    String? errorMessage,
  }) {
    return ProductStateState(
      isLoading: isLoading ?? this.isLoading,
      productStates: productStates ?? this.productStates,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  factory ProductStateState.initial() => const ProductStateState();

  factory ProductStateState.loading() => const ProductStateState(isLoading: true);

  factory ProductStateState.success(List<ProductStateEntity> states) {
    return ProductStateState(productStates: states);
  }

  factory ProductStateState.failure(String errorMessage) => ProductStateState(errorMessage: errorMessage);
}
