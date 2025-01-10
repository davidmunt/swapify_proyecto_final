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
    );
  }
}

class LikeProductParams {
  final String userId;
  final int productId;

  LikeProductParams({required this.userId, required this.productId});
}
