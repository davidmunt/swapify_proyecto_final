class ProductViewState {
  final bool isLoading;
  final String? errorMessage;

  const ProductViewState({
    this.isLoading = false,
    this.errorMessage,
  });

  ProductViewState copyWith({
    bool? isLoading,
    String? errorMessage,
  }) {
    return ProductViewState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  factory ProductViewState.initial() => const ProductViewState();

  factory ProductViewState.loading() => const ProductViewState(isLoading: true);

  factory ProductViewState.failure(String errorMessage) => ProductViewState(errorMessage: errorMessage);
}