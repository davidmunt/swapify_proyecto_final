import 'package:dartz/dartz.dart';
import 'package:swapify/core/failure.dart';
import 'package:swapify/data/models/user_model.dart';
import 'package:swapify/domain/entities/user.dart';

abstract class UserRepository {
  Future<Either<Failure, UserEntity>> signIn(String email, String password);
  Future<Either<Failure, String>> isLoggedIn();
  Future<Either<Failure, void>> logout();
}