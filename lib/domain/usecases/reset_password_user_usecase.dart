import 'package:dartz/dartz.dart';
import 'package:swapify/core/failure.dart';
import 'package:swapify/core/usecase.dart';
import 'package:swapify/domain/repositories/user_repository.dart'; //resetPassword

class ResetPassUserUsecase implements UseCase<void, ResetParams> {
  final UserRepository repository;
  ResetPassUserUsecase(this.repository);

  @override
  Future<Either<Failure, void>> call(ResetParams params) async {
    return repository.resetPassword(params.email);
  }
}

class ResetParams {
  final String email;
  ResetParams({required this.email});
}