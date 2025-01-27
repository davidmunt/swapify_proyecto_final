import 'package:swapify/domain/entities/chat.dart';

class ChatModel {
  final String productOwnerId;
  final String potBuyerId;
  final int productId;
  final List<Map<String, dynamic>> messages;

  ChatModel({
    required this.productOwnerId,
    required this.potBuyerId,
    required this.productId,
    required this.messages,
  });

  factory ChatModel.fromFirestore(Map<String, dynamic> map) {
    return ChatModel(
      productOwnerId: map['productOwnerId'] as String,
      potBuyerId: map['potBuyerId'] as String,
      productId: map['productId'] as int,
      messages: List<Map<String, dynamic>>.from(map['messages'] ?? []),
    );
  }

  ChatEntity toEntity() {
    return ChatEntity(
      productOwnerId: productOwnerId,
      potBuyerId: potBuyerId,
      productId: productId,
      messages: messages,
    );
  }
}
