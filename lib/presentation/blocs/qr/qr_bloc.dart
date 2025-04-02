import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:swapify/domain/usecases/get_qr_product_exchange_usecase.dart';
import 'package:swapify/domain/usecases/get_qr_product_payment_usecase.dart';
import 'package:swapify/presentation/blocs/qr/qr_event.dart';
import 'package:swapify/presentation/blocs/qr/qr_state.dart';

class QRBloc extends Bloc<QREvent, QRState> {
  final GetQRProductPaymentUseCase getQRUseCase;
  final GetQRProductExchangeUseCase getQRExchangeUseCase;

  QRBloc(this.getQRUseCase, this.getQRExchangeUseCase) : super(QRState.initial()) {
    //obtiene qr para la venta de un prducto
    on<GetQRButtonPressed>((event, emit) async {
      emit(QRState.loading());
      try {
        final result = await getQRUseCase(GetQRProductPaymentParams(
          productId: event.productId,
          userId: event.userId,
        ));
        result.fold(
          (failure) => emit(QRState.failure("Fallo al obtener el QR para el pago del producto")),
          (qrEntity) => emit(QRState.success(qrEntity)),
        );
      } catch (e) {
        emit(QRState.failure("Fallo al obtener el QR para el pago del producto: $e"));
      }
    });

    //obtiene qr para el intercambio entre dos productos
    on<GetQRExchangeButtonPressed>((event, emit) async {
      emit(QRState.loading());
      try {
        final result = await getQRExchangeUseCase(GetQRProductExchangeParams(
          productId: event.productId,
          userId: event.userId,
          productExchangedId: event.productExchangedId,
        ));
        result.fold(
          (failure) => emit(QRState.failure("Fallo al obtener el QR para el intercambio del producto")),
          (qrEntity) => emit(QRState.success(qrEntity)),
        );
      } catch (e) {
        emit(QRState.failure("Fallo al obtener el QR para el intercambio del producto: $e"));
      }
    });
  }
}
