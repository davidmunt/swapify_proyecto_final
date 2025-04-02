import 'package:dartz/dartz.dart';
import 'package:swapify/core/failure.dart';
import 'package:swapify/core/usecase.dart';
import 'package:swapify/domain/repositories/user_repository.dart';

class ChangeUserPasswordUseCase implements UseCase<void, ChangeUserPasswordParams> {
  final UserRepository repository;

  ChangeUserPasswordUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(ChangeUserPasswordParams params) {
    return repository.changeUserPassword(
      userId: params.userId,
      password: params.password,
      token: params.token,
    );
  }
}

class ChangeUserPasswordParams {
  final String userId;
  final String password;
  final String token;

  ChangeUserPasswordParams({
    required this.userId,
    required this.password,
    required this.token,
  });
}
