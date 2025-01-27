import 'package:swapify/core/usecase.dart';
import 'package:swapify/domain/entities/user.dart';
import 'package:swapify/domain/repositories/user_repository.dart';

class GetUsersInfoUseCase implements UseCase<List<UserEntity>, NoParams> {
  final UserRepository repository;

  GetUsersInfoUseCase(this.repository);

  @override
  Future<List<UserEntity>> call(NoParams params) async {
    final result = await repository.getUsersInfo();
    return result.fold(
      (failure) => throw Exception('Error al obtener la información de los usuarios'),
      (usersEntity) => usersEntity,
    );
  }
}
