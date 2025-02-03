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
