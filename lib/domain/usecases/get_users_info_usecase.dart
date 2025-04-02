import 'package:swapify/core/usecase.dart';
import 'package:swapify/domain/entities/user.dart';
import 'package:swapify/domain/repositories/user_repository.dart';

class GetUsersInfoUseCase implements UseCase<List<UserEntity>, GetUsersInfoParams> {
  final UserRepository repository;

  GetUsersInfoUseCase(this.repository);

  @override
  Future<List<UserEntity>> call(GetUsersInfoParams params) async {
    final result = await repository.getUsersInfo(params.token);
    return result.fold(
      (failure) => throw Exception('Error al obtener la información de los usuarios'),
      (usersEntity) => usersEntity,
    );
  }
}

class GetUsersInfoParams {
  final String token;

  GetUsersInfoParams({required this.token});
}
