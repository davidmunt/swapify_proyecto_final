import 'package:dartz/dartz.dart';
import 'package:swapify/core/failure.dart';
import 'package:swapify/core/usecase.dart';
import 'package:swapify/domain/repositories/user_repository.dart';

class LoginToGetTokenFromBackendUseCase implements UseCase<Either<Failure, String>, LoginToGetTokenFromBackendParams> {
  final UserRepository repository;

  LoginToGetTokenFromBackendUseCase(this.repository);

  @override
  Future<Either<Failure, String>> call(LoginToGetTokenFromBackendParams params) async {
    return await repository.loginToGetTokenFromBackend(
      email: params.email,
      password: params.password,
    );
  }
}

class LoginToGetTokenFromBackendParams {
  final String email;
  final String password;

  LoginToGetTokenFromBackendParams({
    required this.email,
    required this.password,
  });
}
