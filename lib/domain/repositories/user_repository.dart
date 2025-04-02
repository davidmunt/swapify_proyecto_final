import 'package:dartz/dartz.dart';
import 'package:swapify/core/failure.dart';
import 'package:swapify/domain/entities/user.dart';
import 'package:image_picker/image_picker.dart';

abstract class UserRepository {
  Future<Either<Failure, UserEntity>> signIn(String email, String password);
  Future<Either<Failure, String>> isLoggedIn();
  Future<Either<Failure, void>> signUp(String email, String password);
  Future<Either<Failure, void>> saveUserInfo({
    required String uid,
    required String password,
    required String name,
    required String surname,
    required String email,
    required int telNumber,
    required DateTime dateBirth,
  });
  Future<Either<Failure, void>> changeUserInfo({
    required String uid,
    required String name,
    required String surname,
    required int telNumber,
    required DateTime dateBirth,
    required String token,
  });
  Future<Either<Failure, String>> loginToGetTokenFromBackend({
    required String email,
    required String password,
  });
  Future<Either<Failure, void>> saveUserNotificationToken({
    required String userId,
    required String? notificationToken,
    required String token,
  });
  Future<Either<Failure, void>> changeUserAvatar({
    required String uid,
    required XFile image,
  });
  Future<Either<Failure, UserEntity>> getUserInfo(String uid, String token);
  Future<Either<Failure, List<UserEntity>>> getUsersInfo(String token);
  Future<Either<Failure, void>> resetPassword(String email);
  Future<Either<Failure, void>> changePassword(String password);
  Future<Either<Failure, void>> logout();
  Future<Either<Failure, void>> deleteUser(String id, String token);
  Future<Either<Failure, void>> addBalanceToUser({
    required String userId,
    required int balanceToAdd,
    required String token,
  });
  Future<Either<Failure, void>> changeUserPassword({
    required String userId,
    required String password,
    required String token,
  });
  Future<Either<Failure, void>> addRatingToUser({
    required String userId,
    required String customerId,
    required int productId,
    required int rating,
    required String token,
  });
}