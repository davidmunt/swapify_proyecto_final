import 'package:swapify/domain/entities/qr.dart';

class QRState {
  final bool isLoading;
  final QREntity? qrEntity;
  final String? errorMessage;

  const QRState({
    this.isLoading = false,
    this.qrEntity,
    this.errorMessage,
  });

  QRState copyWith({
    bool? isLoading,
    QREntity? qrEntity,
    String? errorMessage,
  }) {
    return QRState(
      isLoading: isLoading ?? this.isLoading,
      qrEntity: qrEntity ?? this.qrEntity,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  factory QRState.initial() => const QRState();

  factory QRState.loading() => const QRState(isLoading: true);

  factory QRState.success(QREntity qrEntity) {
    return QRState(qrEntity: qrEntity);
  }

  factory QRState.failure(String errorMessage) => QRState(errorMessage: errorMessage);
}
