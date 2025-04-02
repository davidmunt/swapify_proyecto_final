import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:swapify/domain/usecases/get_product_category_usecase.dart';
import 'package:swapify/presentation/blocs/product_category/product_category_event.dart';
import 'package:swapify/presentation/blocs/product_category/product_category_state.dart';

class ProductCategoryBloc extends Bloc<ProductCategoryEvent, ProductCategoryState> {
  final GetProductCategoryUseCase getProductCategoryUseCase;

  ProductCategoryBloc(this.getProductCategoryUseCase) : super(ProductCategoryState.initial()) {
    //obtiene las categorias para los productos
    on<GetProductCategoryButtonPressed>((event, emit) async {
      emit(ProductCategoryState.loading());
      try {
        final categories = await getProductCategoryUseCase(GetProductCategoryParams());
        emit(ProductCategoryState.success(categories));
      } catch (e) {
        emit(ProductCategoryState.failure("Fallo al obtener las categorias del producto: $e"));
      }
    });
  }
}
