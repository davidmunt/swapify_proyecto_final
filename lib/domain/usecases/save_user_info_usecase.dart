import 'package:dartz/dartz.dart';
import 'package:swapify/core/failure.dart';
import 'package:swapify/core/usecase.dart';
import 'package:swapify/domain/repositories/user_repository.dart';

class SaveUserInfoUseCase implements UseCase<void, SaveUserInfoParams> {
  final UserRepository repository;

  SaveUserInfoUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(SaveUserInfoParams params) {
    return repository.saveUserInfo(
      uid: params.uid,
      name: params.name,
      surname: params.surname,
      email: params.email,
      telNumber: params.telNumber,
      dateBirth: params.dateBirth,
    );
  }
}

class SaveUserInfoParams {
  final String uid;
  final String name;
  final String surname;
  final String email;
  final int telNumber;
  final DateTime dateBirth;

  SaveUserInfoParams({
    required this.uid,
    required this.name,
    required this.surname,
    required this.email,
    required this.telNumber,
    required this.dateBirth,
  });
}
