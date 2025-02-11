import 'package:dartz/dartz.dart';
import 'package:swapify/core/failure.dart';
import 'package:swapify/core/usecase.dart';
import 'package:swapify/domain/repositories/user_repository.dart';

class SaveUserNotificationTokenUseCase implements UseCase<void, SaveUserNotificationTokenParams> {
  final UserRepository repository;

  SaveUserNotificationTokenUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(SaveUserNotificationTokenParams params) {
    return repository.saveUserNotificationToken(
      userId: params.userId,
      notificationToken: params.notificationToken,
    );
  }
}

class SaveUserNotificationTokenParams {
  final String userId;
  final String? notificationToken;

  SaveUserNotificationTokenParams({
    required this.userId,
    required this.notificationToken,
  });
}
