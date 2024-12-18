import 'package:dartz/dartz.dart';
import 'package:swapify/core/failure.dart';
import 'package:swapify/domain/entities/user.dart';
import 'package:swapify/data/models/user_model.dart';
import 'package:swapify/domain/repositories/user_repository.dart';
import 'package:swapify/data/datasources/user_remote_datasource.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserRepositoryImpl implements UserRepository {
  final FirebaseAuthDataSource dataSource;
  final SharedPreferences prefs;

  UserRepositoryImpl(this.dataSource, this.prefs);

  @override
  Future<Either<Failure, UserEntity>> signIn(
      String email, String password) async {
    try {
      UserModel user = await dataSource.signIn(email, password);
      await prefs.setString('email', user.email);
      await prefs.setString('password', password);
      await prefs.setString('id', user.id);
      //UserModel user = await dataSource.signInWithGoogle();
      return Right(user.toEntity());
    } catch (e) {
      print(e);
      return Left(AuthFailure());
    }
  }

  @override
  Future<Either<Failure, void>> resetPassword(String email) async {
    try {
      await dataSource.resetPassword(email);
      return const Right(null);
    } catch (e) {
      print(e);
      return Left(AuthFailure());
    }
  }

  @override
  Future<Either<Failure, void>> saveUserInfo({
    required String uid,
    required String name,
    required String surname,
    required String email,
    required int telNumber,
    required DateTime dateBirth,
  }) async {
    try {
      await dataSource.saveUserInfo(
        uid: uid,
        name: name,
        surname: surname,
        email: email,
        telNumber: telNumber,
        dateBirth: dateBirth,
      );
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, void>> signUp(String email, String password) async {
    try {
      await dataSource.signUp(email, password);
      return const Right(null);
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
      await prefs.remove('email');
      await prefs.remove('password');
      await prefs.remove('id');
      return const Right(null);
    } catch (e) {
      return Left(AuthFailure());
    }
  }
}
