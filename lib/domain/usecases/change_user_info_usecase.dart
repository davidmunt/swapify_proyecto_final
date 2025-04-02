import 'package:dartz/dartz.dart';
import 'package:swapify/core/failure.dart';
import 'package:swapify/core/usecase.dart';
import 'package:swapify/domain/repositories/user_repository.dart';

class ChangeUserInfoUseCase implements UseCase<void, ChangeUserInfoParams> {
  final UserRepository repository;

  ChangeUserInfoUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(ChangeUserInfoParams params) {
    return repository.changeUserInfo(
      uid: params.uid,
      name: params.name,
      surname: params.surname,
      telNumber: params.telNumber,
      dateBirth: params.dateBirth,
      token: params.token,
    );
  }
}

class ChangeUserInfoParams {
  final String uid;
  final String name;
  final String surname;
  final int telNumber;
  final DateTime dateBirth;
  final String token;

  ChangeUserInfoParams({
    required this.uid,
    required this.name,
    required this.surname,
    required this.telNumber,
    required this.dateBirth,
    required this.token,
  });
}
