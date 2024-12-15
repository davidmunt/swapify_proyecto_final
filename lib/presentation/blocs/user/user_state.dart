//No extendemos a equatable para que siempre se considere un estado distinto de otro. Simplemente para poder mostrar el
class UserState {
  final bool isLoading;
  final String? email;
  final String? errorMessage;

  const UserState({
    this.isLoading = false,
    this.email,
    this.errorMessage,
  });

  // Método copyWith
  UserState copyWith({
    bool? isLoading,
    String? email,
    String? errorMessage,
  }) {
    return UserState(
      isLoading: isLoading ?? this.isLoading,
      email: email ?? this.email,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  // Estados predefinidos
  factory UserState.initial() => const UserState();

  factory UserState.loading() => const UserState(isLoading: true);

  factory UserState.success(String email) => UserState(email: email);

  factory UserState.failure(String errorMessage) =>
      UserState(errorMessage: errorMessage);

  // @override
  // List<Object?> get props => [isLoading, email, errorMessage];
}
