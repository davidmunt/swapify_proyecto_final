import 'package:dartz/dartz.dart';
import 'package:swapify/core/failure.dart';
import 'package:swapify/domain/entities/qr.dart';

abstract class QRRepository {
  Future<Either<Failure, QREntity>> getQRProductPayment(String userId, int productId);
  Future<Either<Failure, QREntity>> getQRProductExchange(String userId, int productId, int productExchangedId);
}
