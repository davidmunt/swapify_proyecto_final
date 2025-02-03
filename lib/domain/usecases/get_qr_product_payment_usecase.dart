import 'package:swapify/domain/entities/qr.dart';
import 'package:swapify/domain/repositories/qr_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:swapify/core/failure.dart';

class GetQRProductPaymentUseCase {
  final QRRepository repository;

  GetQRProductPaymentUseCase(this.repository);

  Future<Either<Failure, QREntity>> call(GetQRProductPaymentParams params) {
    return repository.getQRProductPayment(params.userId, params.productId);
  }
}

class GetQRProductPaymentParams {
  final String userId;
  final int productId;

  GetQRProductPaymentParams({required this.productId, required this.userId});
}
