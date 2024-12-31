import 'package:swapify/domain/entities/user.dart';

class UserState {
  final bool isLoading;
  final UserEntity? user;
  final String? errorMessage;

  const UserState({
    this.isLoading = false,
    this.user,
    this.errorMessage,
  });

  UserState copyWith({
    bool? isLoading,
    UserEntity? user,
    String? errorMessage,
  }) {
    return UserState(
      isLoading: isLoading ?? this.isLoading,
      user: user ?? this.user,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  factory UserState.initial() => const UserState();

  factory UserState.loading() => const UserState(isLoading: true);

  factory UserState.success(UserEntity user) {
    return UserState(user: user);
  }

  factory UserState.resetPasswordSuccess() => const UserState(
    isLoading: false,
    errorMessage: null,
  );

  factory UserState.changePasswordSuccess() => const UserState(
    isLoading: false,
    errorMessage: null,
  );

  factory UserState.failure(String errorMessage) => UserState(errorMessage: errorMessage);
}
