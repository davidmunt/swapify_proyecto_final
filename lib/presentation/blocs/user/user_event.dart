import 'package:equatable/equatable.dart';

abstract class UserEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoginButtonPressed extends UserEvent {
  final String email;
  final String password;

  LoginButtonPressed({required this.email, required this.password});

  @override
  List<Object?> get props => [email, password];
}

class LogoutButtonPressed extends UserEvent {}

class CheckAuthentication extends UserEvent {}