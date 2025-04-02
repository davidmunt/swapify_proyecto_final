
abstract class ProductViewRepository {
  Future<void> saveProductView({
    required String userId,
    required int productId,
    required String token,
  }); 
}