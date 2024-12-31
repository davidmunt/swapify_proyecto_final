import 'package:dartz/dartz.dart';
import 'package:swapify/core/failure.dart';
import 'package:swapify/core/usecase.dart';
import 'package:swapify/domain/repositories/user_repository.dart';

class SignUpUserUsecase implements UseCase<void, SignUpParams> {
  final UserRepository repository;
  SignUpUserUsecase(this.repository);

  @override
  Future<Either<Failure, void>> call(SignUpParams params) async {
    return repository.signUp(params.email, params.password);
  }
}

class SignUpParams {
  final String email;
  final String password;
  SignUpParams({required this.email, required this.password});
}