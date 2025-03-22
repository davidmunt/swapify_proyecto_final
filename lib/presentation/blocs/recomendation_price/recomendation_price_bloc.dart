import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:swapify/domain/entities/recomendation_price.dart';
import 'package:swapify/domain/usecases/get_recomendation_product_price_usecase.dart';
import 'package:swapify/presentation/blocs/recomendation_price/recomendation_price_event.dart';
import 'package:swapify/presentation/blocs/recomendation_price/recomendation_price_state.dart';

class RecomendationPriceBloc extends Bloc<RecomendationPriceEvent, RecomendationPriceState> {
  final GetRecomendationPriceUseCase getRecomendationPriceUseCase;

  RecomendationPriceBloc(this.getRecomendationPriceUseCase) : super(RecomendationPriceState.initial()) {
    on<GetRecomendationPriceButtonPressed>((event, emit) async {
      emit(RecomendationPriceState.loading());
      try {
        final result = await getRecomendationPriceUseCase(GetRecomendationPriceParams(
          productBrand: event.productBrand,
          productModel: event.productModel,
          description: event.description,
          price: event.price,
          productCategory: event.productCategory,
          productState: event.productState,
        ));

        if (result == null) {
          emit(RecomendationPriceState.success(RecomendationPriceEntity(recomendationPrice: event.price))); 
          return;
        }

        final double recommendedPrice = result.recomendationPrice;
        final double lowerLimit = recommendedPrice * 0.85;
        final double upperLimit = recommendedPrice * 1.15;

        if (event.price < lowerLimit || event.price > upperLimit) {
          emit(RecomendationPriceState.success(RecomendationPriceEntity(recomendationPrice: recommendedPrice)));
        } else {
          emit(RecomendationPriceState.success(RecomendationPriceEntity(recomendationPrice: event.price)));
        }
      } catch (e) {
        emit(RecomendationPriceState.failure("Fallo al obtener el precio recomendado: $e"));
      }
    });
  }
}
