import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:swapify/domain/usecases/get_product_state_usecase.dart';
import 'package:swapify/presentation/blocs/product_state/product_state_event.dart';
import 'package:swapify/presentation/blocs/product_state/product_state_state.dart';

class ProductStateBloc extends Bloc<ProductStateEvent, ProductStateState> {
  final GetProductStateUseCase getProductStateUseCase;

  ProductStateBloc(this.getProductStateUseCase) : super(ProductStateState.initial()) {
    
    on<GetProductStateButtonPressed>((event, emit) async {
      emit(ProductStateState.loading());
      try {
        final states = await getProductStateUseCase(GetProductStateParams());
        emit(ProductStateState.success(states));
      } catch (e) {
        emit(ProductStateState.failure("Fallo al obtener los estados del producto: $e"));
      } 
    });
  }
}