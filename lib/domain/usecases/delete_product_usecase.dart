import 'package:dartz/dartz.dart';
import 'package:swapify/core/failure.dart';
import 'package:swapify/core/usecase.dart';
import 'package:swapify/domain/repositories/product_repository.dart';

class DeleteProductUseCase implements UseCase<void, DeleteProductParams> {
  final ProductRepository repository;

  DeleteProductUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(DeleteProductParams params) async {
    return await repository.deleteProduct(params.id, params.token);
  }
}

class DeleteProductParams {
  final int id;
  final String token;

  DeleteProductParams({required this.id, required this.token});
}