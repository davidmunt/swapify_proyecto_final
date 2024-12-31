import 'package:equatable/equatable.dart';
import 'package:image_picker/image_picker.dart';

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

class SaveUserInfoButtonPressed extends UserEvent {
  final String uid;
  final String name;
  final String surname;
  final String email;
  final int telNumber;
  final DateTime dateBirth;

  SaveUserInfoButtonPressed({
    required this.uid,
    required this.name,
    required this.surname,
    required this.email,
    required this.telNumber,
    required this.dateBirth,
  });

  @override
  List<Object?> get props => [uid, name, surname, email, telNumber];
}

class ChangeUserAvatarButtonPressed extends UserEvent {
  final String uid;
  final XFile image;

  ChangeUserAvatarButtonPressed({required this.uid, required this.image});

  @override
  List<Object?> get props => [uid, image];
}


class SignUpButtonPressed extends UserEvent {
  final String email;
  final String password;
  final String name;
  final String surname;
  final int telNumber;
  final DateTime dateBirth;

  SignUpButtonPressed({required this.email, required this.password, required this.name, required this.surname, required this.telNumber, required this.dateBirth});
}

class ChangeUserInfoButtonPressed extends UserEvent {
  final String uid;
  final String name;
  final String surname;
  final int telNumber;
  final DateTime dateBirth;

  ChangeUserInfoButtonPressed({
    required this.uid,
    required this.name,
    required this.surname,
    required this.telNumber,
    required this.dateBirth,
  });

  @override
  List<Object?> get props => [uid, name, surname, telNumber, dateBirth];
}

class DeleteUserButtonPressed extends UserEvent {
  final String id;

  DeleteUserButtonPressed({required this.id});

  @override
  List<Object?> get props => [id];
}


class ResetPasswordButtonPressed extends UserEvent {
  final String email;

  ResetPasswordButtonPressed({required this.email});
}

class ChangePasswordButtonPressed extends UserEvent {
  final String password;

  ChangePasswordButtonPressed({required this.password});
}

class LogoutButtonPressed extends UserEvent {}

class CheckAuthentication extends UserEvent {}