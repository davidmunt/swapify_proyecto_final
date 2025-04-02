import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:swapify/domain/usecases/save_product_view_usecase.dart';
import 'package:swapify/presentation/blocs/product_view/product_view_event.dart';
import 'package:swapify/presentation/blocs/product_view/product_view_state.dart';

class ProductViewBloc extends Bloc<ProductViewEvent, ProductViewState> {
  final SaveProductViewUsecase saveProductViewUsecase;

  ProductViewBloc(this.saveProductViewUsecase) : super(ProductViewState.initial()) {
    //guarda la visita de un usuario a un producto (lo utilizo para la recomendacio del orden de los productos en mi backend)
    on<SaveProductViewButtonPressed>((event, emit) async {
      emit(ProductViewState.loading());
      try {
        await saveProductViewUsecase(SaveProductViewParams(
          userId: event.userId,
          productId: event.productId,
          token: event.token,
        ));
        emit(ProductViewState.initial()); 
      } catch (e) {
        emit(ProductViewState.failure("Fallo al guardar la visita del producto: $e"));
      }
    });
  }
}
