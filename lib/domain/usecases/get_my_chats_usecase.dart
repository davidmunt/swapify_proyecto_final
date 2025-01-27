import 'package:swapify/core/usecase.dart';
import 'package:swapify/domain/entities/chat.dart';
import 'package:swapify/domain/repositories/chat_repository.dart';

class GetMyChatsUseCase implements UseCase<List<ChatEntity>, GetMyChatsParams> {
  final ChatRepository repository;

  GetMyChatsUseCase(this.repository);

  @override
  Future<List<ChatEntity>> call(GetMyChatsParams params) async {
    final result = await repository.getMyChats(params.userId);
    return result.fold(
      (failure) {
        throw Exception('Error al obtener mis chats');
      },
      (chats) => chats,
    );
  }
}

class GetMyChatsParams {
  final String userId;

  GetMyChatsParams({required this.userId});
}
