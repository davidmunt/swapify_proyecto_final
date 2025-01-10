import 'package:swapify/core/usecase.dart';
import 'package:swapify/domain/entities/product_state.dart';
import 'package:swapify/domain/repositories/product_state_repository.dart';

class GetProductStateUseCase implements UseCase<List<ProductStateEntity>, GetProductStateParams> {
  final ProductStateRepository repository;

  GetProductStateUseCase(this.repository);

  @override
  Future<List<ProductStateEntity>> call(GetProductStateParams params) async {
    final result = await repository.getProductState();
    return result.fold(
      (failure) => throw Exception('Error al obtener los estados del producto: $failure'),
      (states) => states,
    );
  }
}

class GetProductStateParams {}