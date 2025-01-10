import 'package:dartz/dartz.dart';
import 'package:swapify/core/failure.dart';
import 'package:swapify/core/usecase.dart';
import 'package:swapify/domain/entities/user.dart';
import 'package:swapify/domain/repositories/user_repository.dart';

class SigninUserUseCase implements UseCase<void, LoginParams> {
  final UserRepository repository;
  SigninUserUseCase(this.repository);

  @override
  Future<Either<Failure, UserEntity>> call(LoginParams params) async {
    return repository.signIn(params.email, params.password);
  }
}

class LoginParams {
  final String email;
  final String password;
  LoginParams({required this.email, required this.password});
}
