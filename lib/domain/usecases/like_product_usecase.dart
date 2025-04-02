import 'package:dartz/dartz.dart';
import 'package:swapify/core/failure.dart';
import 'package:swapify/core/usecase.dart';
import 'package:swapify/domain/repositories/product_repository.dart';

class LikeProductUseCase implements UseCase<void, LikeProductParams> {
  final ProductRepository repository;

  LikeProductUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(LikeProductParams params) async {
    return await repository.likeProduct(
      productId: params.productId, 
      userId: params.userId,
      token: params.token,
    );
  }
}

class LikeProductParams {
  final String userId;
  final int productId;
  final String token;

  LikeProductParams({required this.userId, required this.productId, required this.token});
}
