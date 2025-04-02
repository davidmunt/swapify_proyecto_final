import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:swapify/domain/usecases/get_product_sale_state_usecase.dart';
import 'package:swapify/presentation/blocs/product_sale_state/product_sale_state_event.dart';
import 'package:swapify/presentation/blocs/product_sale_state/product_sale_state_state.dart';

class ProductSaleStateBloc extends Bloc<ProductSaleStateEvent, ProductSaleStateState> {
  final GetProductSaleStateUseCase getProductSaleStateUseCase;

  ProductSaleStateBloc(this.getProductSaleStateUseCase) : super(ProductSaleStateState.initial()) {
    //obtiene los estados de venta para los productos
    on<GetProductSaleStateButtonPressed>((event, emit) async {
      emit(ProductSaleStateState.loading());
      try {
        final saleStates = await getProductSaleStateUseCase(GetProductSaleStateParams());
        emit(ProductSaleStateState.success(saleStates));
      } catch (e) {
        emit(ProductSaleStateState.failure("Fallo al obtener los estados de venta del producto: $e"));
      }
    });
  }
}