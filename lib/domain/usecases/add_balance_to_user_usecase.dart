import 'package:dartz/dartz.dart';
import 'package:swapify/core/failure.dart';
import 'package:swapify/core/usecase.dart';
import 'package:swapify/domain/repositories/user_repository.dart';

class AddBalanceToUserUseCase implements UseCase<void, AddBalanceToUserParams> {
  final UserRepository repository;

  AddBalanceToUserUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(AddBalanceToUserParams params) {
    return repository.addBalanceToUser(
      userId: params.userId,
      balanceToAdd: params.balanceToAdd,
      token: params.token,
    );
  }
}

class AddBalanceToUserParams {
  final String userId;
  final int balanceToAdd;
  final String token;

  AddBalanceToUserParams({
    required this.userId,
    required this.balanceToAdd,
    required this.token,
  });
}
