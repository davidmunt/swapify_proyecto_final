import 'package:equatable/equatable.dart';

abstract class ProductStateEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class GetProductStateButtonPressed extends ProductStateEvent {}