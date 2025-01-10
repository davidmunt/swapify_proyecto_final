import 'package:swapify/domain/repositories/product_repository.dart';
import 'package:swapify/core/usecase.dart';
import 'package:image_picker/image_picker.dart';

class UploadProductImagesUseCase implements UseCase<void, UploadProductImagesParams> {
  final ProductRepository repository;

  UploadProductImagesUseCase(this.repository);

  @override
  Future<void> call(UploadProductImagesParams params) async {
    return await repository.uploadProductImages(
      productId: params.productId,
      images: params.images,
    );
  }
}

class UploadProductImagesParams {
  final int productId;
  final List<XFile> images;

  UploadProductImagesParams({
    required this.productId,
    required this.images,
  });
}
