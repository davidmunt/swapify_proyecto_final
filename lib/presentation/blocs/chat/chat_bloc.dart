import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:swapify/domain/entities/chat.dart';
import 'package:swapify/domain/usecases/delete_chat_where_is_product_usecase.dart';
import 'package:swapify/domain/usecases/get_chat_usecse.dart';
import 'package:swapify/domain/usecases/get_my_chats_usecase.dart';
import 'package:swapify/domain/usecases/save_message_image_usecase.dart';
import 'package:swapify/domain/usecases/send_message_chat_usecase.dart';
import 'package:swapify/domain/usecases/send_notification_to_other_user_usecase.dart';
import 'package:swapify/domain/usecases/update_exchange_status_chat_usecase.dart';
import 'package:swapify/presentation/blocs/chat/chat_event.dart';
import 'package:swapify/presentation/blocs/chat/chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final SendMessageChatUsecase sendMessageChatUsecase;
  final UploadMessageImageUsecase uploadMessageImageUsecase;
  final GetMyChatsUseCase getMyChatsUseCase;
  final GetChatUseCase getChatUseCase;
  final SendNotificationToOtherUserUseCase sendNotificationToOtherUserUseCase;
  final UpdateExchangeStatusChatUseCase updateExchangeStatusChatUseCase;
  final DeleteChatWhereIsProductUsecase deleteChatWhereIsProductUsecase;

  ChatBloc(
    this.sendMessageChatUsecase,
    this.uploadMessageImageUsecase,
    this.getMyChatsUseCase,
    this.getChatUseCase,
    this.sendNotificationToOtherUserUseCase,
    this.updateExchangeStatusChatUseCase,
    this.deleteChatWhereIsProductUsecase,
  ) : super(ChatState.initial()) {
    
    //obtiene todos los chats en los que participa el usuario
    on<GetMyChatsButtonPressed>((event, emit) async {
      emit(ChatState.loading());
      try {
        final chats = await getMyChatsUseCase.call(GetMyChatsParams(userId: event.userId));
        emit(ChatState.success(chats));
      } catch (e) {
        emit(ChatState.failure("Error al obtener los chats: $e"));
      }
    });

    //actualiza el estado de aceptacion de una propuesta de intercambio dentro del chat
    on<UpdateExchangeStatusChatButtonPressed>((event, emit) async {
      emit(ChatState.loading());
      try {
        await updateExchangeStatusChatUseCase.call(
          UpdateExchangeStatusChatParams(
            productOwnerId: event.productOwnerId,
            potBuyerId: event.potBuyerId,
            productId: event.productId,
            idProduct: event.idProduct,
            accepted: event.accepted,
          ),
        );
        final updatedChats = await getMyChatsUseCase.call(GetMyChatsParams(userId: event.productOwnerId));
        emit(ChatState.success(updatedChats));
      } catch (e) {
        emit(ChatState.failure("Error al actualizar el estado del intercambio: $e"));
      }
    });

    
    //elimina un chat o una propuesta de intercambio asociada a un producto
    on<DeleteChatWhereIsProductButtonPressed>((event, emit) async {
      emit(ChatState.loading());
      try {
        await deleteChatWhereIsProductUsecase.call(
          DeleteChatWhereIsProductParams(
            productId: event.productId,
          ),
        );
        final updatedChats = await getMyChatsUseCase.call(GetMyChatsParams(userId: event.userId));
        emit(ChatState.success(updatedChats));
      } catch (e) {
        emit(ChatState.failure("Error al actualizar el estado del intercambio: $e"));
      }
    });

    //reinicia el estado del ChatBloc a su estado inicial
    on<ResetChatStateEvent>((event, emit) {
      emit(ChatState.initial());
    });

    //envia un mensaje, iamgen o propuesta de intercambio al chat, solo puede ser una a la vez
    //(el id del chat se forma juntando: (productOwnerId+potBuyerId+productId))
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
            idProduct: null,
            productImage: null,
            dateMessageSent: event.dateMessageSent,
          ));
          await sendNotificationToOtherUserUseCase.call(SendNotificationToOtherUserParams(
            productId: event.productId,
            text: event.message, 
            sender: event.senderId,
            reciver: receiverId,
          ));
        }
        else if (event.image != null) {
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
            idProduct: null,
            productImage: null,
            dateMessageSent: event.dateMessageSent,
          ));
          await sendNotificationToOtherUserUseCase.call(SendNotificationToOtherUserParams(
            productId: event.productId,
            text: null, 
            sender: event.senderId,
            reciver: receiverId,
          ));
        }
        else if (event.idProduct != null) {
          await sendMessageChatUsecase.call(SendMessageParams(
            productOwnerId: event.productOwnerId,
            potBuyerId: event.potBuyerId,
            productId: event.productId,
            senderId: event.senderId,
            message: null,
            imagePath: null,
            idProduct: event.idProduct,
            productImage: event.productImage,
            dateMessageSent: event.dateMessageSent,
          ));
          await sendNotificationToOtherUserUseCase.call(SendNotificationToOtherUserParams(
            productId: event.productId,
            text: "Te han ofrecido un intercambio", 
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
    
    //obtiene lun chat por el id del chat
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
