import 'package:swapify/data/datasources/product_view_remote_datasource.dart';
import 'package:swapify/domain/repositories/product_view_repository.dart';

class ProductViewRepositoryImpl implements ProductViewRepository {
  final ProductViewDataSource dataSource;

  ProductViewRepositoryImpl(this.dataSource);

  @override
  Future<void> saveProductView({
    required String userId,
    required int productId,
  }) async {
    return await dataSource.saveProductView(
      userId: userId,
      productId: productId,
    );
  }
}
