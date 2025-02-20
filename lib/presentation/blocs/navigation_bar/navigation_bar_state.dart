class NavigationBarState {
  final bool isLoading;
  final int? numNavigationBar;
  final String? errorMessage;

  const NavigationBarState({
    this.isLoading = false,
    this.numNavigationBar,
    this.errorMessage,
  });

  NavigationBarState copyWith({
    bool? isLoading,
    int? numNavigationBar,
    String? errorMessage,
  }) {
    return NavigationBarState(
      isLoading: isLoading ?? this.isLoading,
      numNavigationBar: numNavigationBar ?? this.numNavigationBar,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  factory NavigationBarState.initial() => const NavigationBarState();

  factory NavigationBarState.loading() => const NavigationBarState(isLoading: true);

  factory NavigationBarState.success(int numNavigationBar) {
    return NavigationBarState(numNavigationBar: numNavigationBar);
  }

  factory NavigationBarState.failure(String errorMessage) => NavigationBarState(errorMessage: errorMessage);
}
