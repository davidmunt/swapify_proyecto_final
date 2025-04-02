import 'package:swapify/domain/entities/user.dart';

class UserState {
  final bool isLoading;
  final UserEntity? user;
  final List<UserEntity>? users;
  final String? token;
  final String? errorMessage;

  const UserState({
    this.isLoading = false,
    this.user,
    this.users,
    this.token,
    this.errorMessage,
  });

  UserState copyWith({
    bool? isLoading,
    UserEntity? user,
    List<UserEntity>? users,
    String? token,
    String? errorMessage,
  }) {
    return UserState(
      isLoading: isLoading ?? this.isLoading,
      user: user ?? this.user,
      users: users ?? this.users,
      token: token ?? this.token,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  factory UserState.initial() => const UserState();

  factory UserState.loading() => const UserState(isLoading: true);

  factory UserState.success(UserEntity user) {
    return UserState(user: user);
  }

  factory UserState.successList(List<UserEntity> users) {
    return UserState(users: users);
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
