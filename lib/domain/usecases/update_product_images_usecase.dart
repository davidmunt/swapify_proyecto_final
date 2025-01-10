import 'package:swapify/domain/repositories/product_repository.dart';
import 'package:swapify/core/usecase.dart';
import 'package:image_picker/image_picker.dart';

class UpdateProductImagesUseCase implements UseCase<void, UpdateProductImagesParams> {
  final ProductRepository repository;

  UpdateProductImagesUseCase(this.repository);

  @override
  Future<void> call(UpdateProductImagesParams params) async {
    return await repository.updateProductImages(
      productId: params.productId,
      images: params.images,
    );
  }
}

class UpdateProductImagesParams {
  final int productId;
  final List<XFile> images;

  UpdateProductImagesParams({
    required this.productId,
    required this.images,
  });
}
