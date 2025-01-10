import 'package:dartz/dartz.dart';
import 'package:swapify/core/failure.dart';
import 'package:swapify/core/usecase.dart';
import 'package:swapify/domain/repositories/user_repository.dart';

class GetCurrentUserUseCase implements UseCase<Either<Failure, String?>, NoParams> {
  final UserRepository repository;
  GetCurrentUserUseCase(this.repository);

  @override
  Future<Either<Failure, String>> call(NoParams params) async {
    return repository.isLoggedIn();
  }
}
