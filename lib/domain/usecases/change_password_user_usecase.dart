import 'package:dartz/dartz.dart';
import 'package:swapify/core/failure.dart';
import 'package:swapify/core/usecase.dart';
import 'package:swapify/domain/repositories/user_repository.dart'; 

class ChangePassUserUsecase implements UseCase<void, ChangeParams> {
  final UserRepository repository;
  ChangePassUserUsecase(this.repository);

  @override
  Future<Either<Failure, void>> call(ChangeParams params) async {
    return repository.changePassword(params.password);
  }
}

class ChangeParams {
  final String password;
  ChangeParams({required this.password});
}