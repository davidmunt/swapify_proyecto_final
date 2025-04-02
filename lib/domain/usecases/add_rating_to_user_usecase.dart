import 'package:dartz/dartz.dart';
import 'package:swapify/core/failure.dart';
import 'package:swapify/core/usecase.dart';
import 'package:swapify/domain/repositories/user_repository.dart';

class AddRatingToUserUseCase implements UseCase<void, AddRatingToUserParams> {
  final UserRepository repository;

  AddRatingToUserUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(AddRatingToUserParams params) {
    return repository.addRatingToUser(
      userId: params.userId,
      customerId: params.customerId,
      productId: params.productId,
      rating: params.rating,
      token: params.token,
    );
  }
}

class AddRatingToUserParams {
  final String userId;
  final String customerId;
  final int productId;
  final int rating;
  final String token;

  AddRatingToUserParams({
    required this.userId,
    required this.customerId,
    required this.productId,
    required this.rating,
    required this.token,
  });
}
