import 'package:dartz/dartz.dart';
import 'package:swapify/core/failure.dart';
import 'package:swapify/core/usecase.dart';
import 'package:swapify/domain/repositories/user_repository.dart';

class DeleteUserUseCase implements UseCase<void, DeleteUserParams> {
  final UserRepository repository;

  DeleteUserUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(DeleteUserParams params) async {
    return await repository.deleteUser(params.id, params.token);
  }
}

class DeleteUserParams {
  final String id;
  final String token;

  DeleteUserParams({required this.id, required this.token});
}