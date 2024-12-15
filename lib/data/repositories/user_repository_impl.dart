import 'package:dartz/dartz.dart';
import 'package:swapify/core/failure.dart';
import 'package:swapify/domain/entities/user.dart';
import 'package:swapify/data/models/user_model.dart';
import 'package:swapify/domain/repositories/user_repository.dart';
import 'package:swapify/data/datasources/user_remote_datasource.dart';

class UserRepositoryImpl implements UserRepository {
  final FirebaseAuthDataSource dataSource;

  UserRepositoryImpl(this.dataSource);

  @override
  Future<Either<Failure, UserEntity>> signIn(
      String email, String password) async {
    try {
      UserModel user = await dataSource.signIn(email, password);
      //UserModel user = await dataSource.signInWithGoogle();
      return Right(user.toEntity());
    } catch (e) {
      print(e);
      return Left(AuthFailure());
    }
  }

  @override
  Future<Either<Failure, String>> isLoggedIn() async {
    try {
      String? user = dataSource.getCurrentUser();
      return Right(user ?? "NO_USER");
    } catch (e) {
      return Left(AuthFailure());
    }
  }

  @override
  Future<Either<Failure, void>> logout() async {
    try {
      await dataSource.logout();
      return const Right(null);
    } catch (e) {
      return Left(AuthFailure());
    }
  }
}
