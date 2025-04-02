import 'package:equatable/equatable.dart';

abstract class ProductViewEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class SaveProductViewButtonPressed extends ProductViewEvent {
  final String userId;
  final int productId;
  final String token;

  SaveProductViewButtonPressed({required this.userId, required this.productId, required this.token});

  @override
  List<Object?> get props => [userId, productId, token];
}
