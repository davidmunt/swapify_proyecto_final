import 'package:swapify/core/usecase.dart';
import 'package:swapify/domain/repositories/chat_repository.dart';
import 'package:image_picker/image_picker.dart';

class UploadMessageImageUsecase implements UseCase<String, UploadMessageImageParams> {
  final ChatRepository repository;

  UploadMessageImageUsecase(this.repository);

  @override
  Future<String> call(UploadMessageImageParams params) async {
    final result = await repository.uploadMessageImage(image: params.image!);
    return result.fold(
      (failure) => throw Exception("Error al subir la imagen: $failure"),
      (path) => path, 
    );
  }
}

class UploadMessageImageParams {
  final XFile? image;

  UploadMessageImageParams({
    required this.image,
  });
}