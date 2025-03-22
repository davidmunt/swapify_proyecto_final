import 'package:equatable/equatable.dart';

abstract class QREvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class GetQRButtonPressed extends QREvent {
  final String userId;
  final int productId;

  GetQRButtonPressed({required this.userId, required this.productId});

  @override
  List<Object?> get props => [userId, productId];
}

class GetQRExchangeButtonPressed extends QREvent {
  final String userId;
  final int productId;
  final int productExchangedId;

  GetQRExchangeButtonPressed({required this.userId, required this.productId, required this.productExchangedId});

  @override
  List<Object?> get props => [userId, productId, productExchangedId];
}
