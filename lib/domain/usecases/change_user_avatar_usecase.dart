import 'package:dartz/dartz.dart';
import 'package:swapify/core/failure.dart';
import 'package:swapify/core/usecase.dart';
import 'package:swapify/domain/repositories/user_repository.dart';
import 'package:image_picker/image_picker.dart';

class ChangeUserAvatarUseCase implements UseCase<void, ChangeUserAvatarParams> {
  final UserRepository repository;

  ChangeUserAvatarUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(ChangeUserAvatarParams params) async {
    return repository.changeUserAvatar(uid: params.uid, image: params.image);
  }
}

class ChangeUserAvatarParams {
  final String uid;
  final XFile image;

  ChangeUserAvatarParams({required this.uid, required this.image});
}
