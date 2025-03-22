import 'package:dartz/dartz.dart';
import 'package:swapify/core/failure.dart';
import 'package:swapify/data/datasources/qr_remote_datasource.dart'; 
import 'package:swapify/data/models/qr_model.dart';
import 'package:swapify/domain/entities/qr.dart';
import 'package:swapify/domain/repositories/qr_repository.dart';

class QRRepositoryImpl implements QRRepository {
  final QRDataSource dataSource;

  QRRepositoryImpl(this.dataSource);

  @override
  Future<Either<Failure, QREntity>> getQRProductPayment(String userId, int productId) async {
    try {
      final qrPath = await dataSource.getQRProductPayment(userId: userId, productId: productId);
      final qrEntity = QRModel(qrPath: qrPath).toEntity();
      return Right(qrEntity);
    } catch (e) {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, QREntity>> getQRProductExchange(String userId, int productId, int productExchangedId) async {
    try {
      final qrPath = await dataSource.getQRProductExchange(userId: userId, productId: productId, productExchangedId: productExchangedId);
      final qrEntity = QRModel(qrPath: qrPath).toEntity();
      return Right(qrEntity);
    } catch (e) {
      return Left(ServerFailure());
    }
  }
}
