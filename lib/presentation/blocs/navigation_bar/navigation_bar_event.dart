import 'package:equatable/equatable.dart';

abstract class NavigationBarEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class ChangeNavigationBarButtonPressed extends NavigationBarEvent {
  final int numNavigationBar;

  ChangeNavigationBarButtonPressed({required this.numNavigationBar});

  @override
  List<Object?> get props => [numNavigationBar];
}
