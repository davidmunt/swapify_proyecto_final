import 'package:swapify/domain/entities/qr.dart';
import 'package:swapify/domain/repositories/qr_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:swapify/core/failure.dart';

class GetQRProductExchangeUseCase {
  final QRRepository repository;

  GetQRProductExchangeUseCase(this.repository);

  Future<Either<Failure, QREntity>> call(GetQRProductExchangeParams params) {
    return repository.getQRProductExchange(params.userId, params.productId, params.productExchangedId);
  }
}

class GetQRProductExchangeParams {
  final String userId;
  final int productId;
  final int productExchangedId;

  GetQRProductExchangeParams({required this.productId, required this.userId, required this.productExchangedId});
}
