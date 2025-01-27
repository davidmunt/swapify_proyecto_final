class ChatEntity {
  final String productOwnerId;
  final String potBuyerId;
  final int productId;
  final List<Map<String, dynamic>> messages;

  ChatEntity({
    required this.productOwnerId,
    required this.potBuyerId,
    required this.productId,
    required this.messages,
  });
}
