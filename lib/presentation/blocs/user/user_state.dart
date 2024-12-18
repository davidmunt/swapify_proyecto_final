class UserState {
  final bool isLoading;
  final String? email;
  final String? id;
  final String? errorMessage;

  const UserState({
    this.isLoading = false,
    this.email,
    this.id,
    this.errorMessage,
  });

  // Método copyWith
  UserState copyWith({
    bool? isLoading,
    String? email,
    String? id,
    String? errorMessage,
  }) {
    return UserState(
      isLoading: isLoading ?? this.isLoading,
      email: email ?? this.email,
      id: id ?? this.id,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  // Estados predefinidos
  factory UserState.initial() => const UserState();

  factory UserState.loading() => const UserState(isLoading: true);

  factory UserState.success([String? email, String? id]) {
    return UserState(email: email, id: id);
  }

  factory UserState.failure(String errorMessage) => UserState(errorMessage: errorMessage);
}
