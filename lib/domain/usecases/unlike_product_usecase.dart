import 'package:dartz/dartz.dart';
import 'package:swapify/core/failure.dart';
import 'package:swapify/core/usecase.dart';
import 'package:swapify/domain/repositories/product_repository.dart';

class UnlikeProductUseCase implements UseCase<void, UnlikeProductParams> {
  final ProductRepository repository;

  UnlikeProductUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(UnlikeProductParams params) async {
    return await repository.unlikeProduct(
      productId: params.productId, 
      userId: params.userId,
      token: params.token
    );
  }
}

class UnlikeProductParams {
  final String userId;
  final int productId;
  final String token;

  UnlikeProductParams({required this.userId, required this.productId, required this.token});
}
