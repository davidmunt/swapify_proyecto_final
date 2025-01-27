import 'package:swapify/core/usecase.dart';
import 'package:swapify/domain/repositories/chat_repository.dart';

class GetChatUseCase implements UseCase<Map<String, dynamic>?, GetChatParams> {
  final ChatRepository repository;

  GetChatUseCase(this.repository);

  @override
  Future<Map<String, dynamic>?> call(GetChatParams params) async {
    final result = await repository.getChat(params.chatId);
    return result.fold(
      (failure) => throw Exception('Error al obtener el chat: $failure'),
      (chat) => chat,
    );
  }
}

class GetChatParams {
  final String chatId;

  GetChatParams({required this.chatId});
}
