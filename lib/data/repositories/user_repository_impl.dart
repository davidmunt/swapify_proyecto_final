import 'package:dartz/dartz.dart';
import 'package:swapify/core/failure.dart';
import 'package:swapify/domain/entities/user.dart';
import 'package:swapify/data/models/user_model.dart';
import 'package:swapify/domain/repositories/user_repository.dart';
import 'package:swapify/data/datasources/user_remote_datasource.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:image_picker/image_picker.dart';

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
      return Right(user.toEntity());
    } catch (e) {
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
  Future<Either<Failure, void>> signUp(String email, String password) async {
    try {
      await dataSource.signUp(email, password);
      return const Right(null);
    } catch (e) {
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
      await dataSource.saveUserInfoToBackend(
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
  Future<Either<Failure, void>> changeUserInfo({
    required String uid,
    required String name,
    required String surname,
    required int telNumber,
    required DateTime dateBirth,
  }) async {
    try {
      await dataSource.changeUserInfoToBackend(
        uid: uid,
        name: name,
        surname: surname,
        telNumber: telNumber,
        dateBirth: dateBirth,
      );
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, void>> saveUserNotificationToken({
    required String userId,
    required String? notificationToken,
  }) async {
    try {
      await dataSource.saveUserNotificationToken(
        userId: userId,
        notificationToken: notificationToken,
      );
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, UserEntity>> getUserInfo(String uid) async {
    try {
      final userData = await dataSource.getUserInfo(uid);
      String? linkAvatar;
      if (userData['avatar_id'] != null) {
        linkAvatar = await dataSource.getLinkUserAvatar(userData['avatar_id'].toString());
      }
      final userModel = UserModel.fromMap(userData).copyWith(linkAvatar: linkAvatar);
      return Right(userModel.toEntity());
    } catch (e) {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, List<UserEntity>>> getUsersInfo() async {
    try {
      final usersData = await dataSource.getUsersInfo();
      final List<UserEntity> users = [];
      for (final userData in usersData) {
        String? linkAvatar;
        if (userData['avatar_id'] != null) {
          linkAvatar = await dataSource.getLinkUserAvatar(userData['avatar_id'].toString());
        }
        final userModel = UserModel.fromMap(userData).copyWith(linkAvatar: linkAvatar);
        users.add(userModel.toEntity());
      }
      return Right(users);
    } catch (e) {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, void>> resetPassword(String email) async {
    try {
      await dataSource.resetPassword(email);
      return const Right(null);
    } catch (e) {
      return Left(AuthFailure());
    }
  }

  @override
  Future<Either<Failure, void>> changePassword(String password) async {
    try {
      await dataSource.changePassword(password);
      await prefs.setString('password', password);
      return const Right(null);
    } catch (e) {
      return Left(AuthFailure());
    }
  }

  @override
  Future<Either<Failure, void>> deleteUser(String id) async {
    try {
      await dataSource.deleteFirebaseUser();
      await dataSource.deleteUserFromBackend(id);
      await prefs.remove('email');
      await prefs.remove('password');
      await prefs.remove('id');
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, void>> changeUserAvatar({
    required String uid,
    required XFile image,
  }) async {
    try {
      await dataSource.changeUserAvatar(uid: uid, image: image);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure());
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

  @override
  Future<Either<Failure, void>> addBalanceToUser({
    required String userId,
    required int balanceToAdd,
  }) async {
    try {
      await dataSource.addBalanceToUser(
        userId: userId,
        balanceToAdd: balanceToAdd,
      );
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, void>> addRatingToUser({
    required String userId,
    required String customerId,
    required int productId,
    required int rating,
  }) async {
    try {
      await dataSource.addRatingToUser(
        userId: userId,
        customerId: customerId,
        productId: productId,
        rating: rating,
      );
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure());
    }
  }
}
