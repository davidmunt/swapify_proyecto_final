import 'package:equatable/equatable.dart';

abstract class PositionEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class GetPositionButtonPressed extends PositionEvent {

  GetPositionButtonPressed();

  @override
  List<Object?> get props => [];
}
