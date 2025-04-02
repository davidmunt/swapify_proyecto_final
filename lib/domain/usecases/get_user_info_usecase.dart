import 'package:swapify/core/usecase.dart';
import 'package:swapify/domain/entities/user.dart';
import 'package:swapify/domain/repositories/user_repository.dart';

class GetUserInfoUseCase implements UseCase<UserEntity, GetUserInfoParams> {
  final UserRepository repository;

  GetUserInfoUseCase(this.repository);

  @override
  Future<UserEntity> call(GetUserInfoParams params) async {
    final result = await repository.getUserInfo(params.uid, params.token);
    return result.fold(
      (failure) {
        throw Exception('Error al obtener la informacion del usuario');
      },
      (userEntity) => userEntity,
    );
  }
}

class GetUserInfoParams {
  final String uid;
  final String token;

  GetUserInfoParams({required this.uid, required this.token});
}
