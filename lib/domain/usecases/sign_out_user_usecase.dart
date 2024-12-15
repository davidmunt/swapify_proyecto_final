import 'package:dartz/dartz.dart';
import 'package:swapify/core/failure.dart';
import 'package:swapify/core/usecase.dart';
import 'package:swapify/domain/repositories/user_repository.dart';

class SignoutUserUseCase implements UseCase<void, NoParams> {
  final UserRepository repository;
  SignoutUserUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(NoParams params) async {
    return repository.logout();
  }
}
