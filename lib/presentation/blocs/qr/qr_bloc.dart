import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:swapify/domain/usecases/get_qr_product_payment_usecase.dart';
import 'package:swapify/presentation/blocs/qr/qr_event.dart';
import 'package:swapify/presentation/blocs/qr/qr_state.dart';

class QRBloc extends Bloc<QREvent, QRState> {
  final GetQRProductPaymentUseCase getQRUseCase;

  QRBloc(this.getQRUseCase) : super(QRState.initial()) {
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
  }
}
