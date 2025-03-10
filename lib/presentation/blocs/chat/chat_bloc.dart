import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:swapify/domain/entities/chat.dart';
import 'package:swapify/domain/usecases/get_chat_usecse.dart';
import 'package:swapify/domain/usecases/get_my_chats_usecase.dart';
import 'package:swapify/domain/usecases/save_message_image_usecase.dart';
import 'package:swapify/domain/usecases/send_message_chat_usecase.dart';
import 'package:swapify/domain/usecases/send_notification_to_other_user_usecase.dart';
import 'package:swapify/presentation/blocs/chat/chat_event.dart';
import 'package:swapify/presentation/blocs/chat/chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final SendMessageChatUsecase sendMessageChatUsecase;
  final UploadMessageImageUsecase uploadMessageImageUsecase;
  final GetMyChatsUseCase getMyChatsUseCase;
  final GetChatUseCase getChatUseCase;
  final SendNotificationToOtherUserUseCase sendNotificationToOtherUserUseCase;

  ChatBloc(
    this.sendMessageChatUsecase,
    this.uploadMessageImageUsecase,
    this.getMyChatsUseCase,
    this.getChatUseCase,
    this.sendNotificationToOtherUserUseCase,
  ) : super(ChatState.initial()) {
    
    on<GetMyChatsButtonPressed>((event, emit) async {
      emit(ChatState.loading());
      try {
        final chats = await getMyChatsUseCase.call(GetMyChatsParams(userId: event.userId));
        emit(ChatState.success(chats));
      } catch (e) {
        emit(ChatState.failure("Error al obtener los chats: $e"));
      }
    });

    on<ResetChatStateEvent>((event, emit) {
      emit(ChatState.initial());
    });

    on<SendMessageButtonPressed>((event, emit) async {
      emit(ChatState.loading());
      try {
        final String receiverId = event.productOwnerId == event.senderId ? event.potBuyerId : event.productOwnerId;
        if (event.message != null) {
          await sendMessageChatUsecase.call(SendMessageParams(
            productOwnerId: event.productOwnerId,
            potBuyerId: event.potBuyerId,
            productId: event.productId,
            senderId: event.senderId,
            message: event.message,
            imagePath: null,
            dateMessageSent: event.dateMessageSent,
          ));
          await sendNotificationToOtherUserUseCase.call(SendNotificationToOtherUserParams(
            productId: event.productId,
            text: event.message, 
            sender: event.senderId,
            reciver: receiverId,
          ));
        }
        if (event.image != null) {
          final uploadedImagePath = await uploadMessageImageUsecase.call(
            UploadMessageImageParams(image: event.image!),
          );
          await sendMessageChatUsecase.call(SendMessageParams(
            productOwnerId: event.productOwnerId,
            potBuyerId: event.potBuyerId,
            productId: event.productId,
            senderId: event.senderId,
            message: null,
            imagePath: uploadedImagePath,
            dateMessageSent: event.dateMessageSent,
          ));
          await sendNotificationToOtherUserUseCase.call(SendNotificationToOtherUserParams(
            productId: event.productId,
            text: null, 
            sender: event.senderId,
            reciver: receiverId,
          ));
        }
        final chatId = "${event.productOwnerId}${event.potBuyerId}${event.productId}";
        add(GetChatButtonPressed(chatId: chatId));
        add(GetMyChatsButtonPressed(userId: event.senderId));
      } catch (e) {
        emit(ChatState.failure("Error al enviar el mensaje: $e"));
      }
    });

    on<GetChatButtonPressed>((event, emit) async {
      emit(ChatState.loading());
      try {
        final result = await getChatUseCase.call(GetChatParams(chatId: event.chatId));
        if (result != null) {
          emit(ChatState.successSingle(ChatEntity(
            productOwnerId: result['productOwnerId'],
            potBuyerId: result['potBuyerId'],
            productId: result['productId'],
            messages: List<Map<String, dynamic>>.from(result['messages']),
          )));
        } else {
          emit(ChatState.failure("Chat no encontrado"));
        }
      } catch (e) {
        emit(ChatState.failure("Error al procesar el evento: $e"));
      }
    });
  }
}
