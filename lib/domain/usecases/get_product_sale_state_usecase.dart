import 'package:swapify/core/usecase.dart';
import 'package:swapify/domain/entities/product_sale_state.dart';
import 'package:swapify/domain/repositories/product_sale_state_repository.dart';

class GetProductSaleStateUseCase implements UseCase<List<ProductSaleStateEntity>, GetProductSaleStateParams> {
  final ProductSaleStateRepository repository;

  GetProductSaleStateUseCase(this.repository);

  @override
  Future<List<ProductSaleStateEntity>> call(GetProductSaleStateParams params) async {
    final result = await repository.getProductSaleState();
    return result.fold(
      (failure) => throw Exception('Error al obtener los estados de venta del producto: $failure'),
      (saleStates) => saleStates,
    );
  }
}

class GetProductSaleStateParams {}