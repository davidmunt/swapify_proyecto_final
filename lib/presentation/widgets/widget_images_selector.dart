import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class WidgetImagesSelector extends StatefulWidget {
  final List<File> selectedImages;
  final String baseUrl;
  final void Function(List<File>) onImagesUpdated;

  const WidgetImagesSelector({
    super.key,
    required this.selectedImages,
    required this.baseUrl,
    required this.onImagesUpdated,
  });

  @override
  State<WidgetImagesSelector> createState() => _WidgetImagesSelectorState();
}

class _WidgetImagesSelectorState extends State<WidgetImagesSelector> {
  final ImagePicker _imagePicker = ImagePicker();

  Future<void> _pickImage(ImageSource source) async {
    try {
      if (source == ImageSource.gallery) {
        final List<XFile>? pickedFiles = await _imagePicker.pickMultiImage();
        if (pickedFiles != null && pickedFiles.isNotEmpty) {
          if (pickedFiles.length + widget.selectedImages.length > 7) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(AppLocalizations.of(context)!.errorMaxSevenImages)),
            );
            return;
          }
          final updatedImages = List<File>.from(widget.selectedImages)
            ..addAll(pickedFiles.map((file) => File(file.path)));

          setState(() {
            widget.onImagesUpdated(updatedImages);
          });
        }
      } else if (source == ImageSource.camera) {
        final XFile? capturedFile = await _imagePicker.pickImage(source: ImageSource.camera);
        if (capturedFile != null) {
          if (widget.selectedImages.length >= 7) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(AppLocalizations.of(context)!.errorMaxSevenImages)),
            );
            return;
          }
          final updatedImages = List<File>.from(widget.selectedImages)
            ..add(File(capturedFile.path));

          setState(() {
            widget.onImagesUpdated(updatedImages);
          });
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context)!.errorSelectingImages)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Wrap(
          spacing: 8.0,
          runSpacing: 8.0,
          children: widget.selectedImages.map((image) {
            final isLocalFile = image.path.startsWith('/data') || image.path.startsWith('file://');
            return Stack(
              children: [
                isLocalFile
                    ? Image.file(
                        File(image.path),
                        width: 100,
                        height: 100,
                        fit: BoxFit.cover,
                      )
                    : Image.network(
                        '${widget.baseUrl}${image.path}',
                        width: 100,
                        height: 100,
                        fit: BoxFit.cover,
                      ),
                Positioned(
                  top: 0,
                  right: 0,
                  child: GestureDetector(
                    onTap: () {
                      final updatedImages = List<File>.from(widget.selectedImages)
                        ..remove(image);

                      setState(() {
                        widget.onImagesUpdated(updatedImages);
                      });
                    },
                    child: const CircleAvatar(
                      radius: 12,
                      backgroundColor: Colors.red,
                      child: Icon(Icons.close, color: Colors.white, size: 16),
                    ),
                  ),
                ),
              ],
            );
          }).toList(),
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton.icon(
              onPressed: () => _pickImage(ImageSource.camera),
              icon: const Icon(Icons.camera),
              label: Text(AppLocalizations.of(context)!.camera),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(150, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            ElevatedButton.icon(
              onPressed: () => _pickImage(ImageSource.gallery),
              icon: const Icon(Icons.photo_library),
              label: Text(AppLocalizations.of(context)!.gallery),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(150, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
