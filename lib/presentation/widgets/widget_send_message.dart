import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/foundation.dart';
import 'dart:typed_data'; 

class SendMessageWidget extends StatefulWidget {
  final Function(String message, XFile? image) onSendMessage;

  const SendMessageWidget({super.key, required this.onSendMessage});

  @override
  State<SendMessageWidget> createState() => _SendMessageWidgetState();
}

class _SendMessageWidgetState extends State<SendMessageWidget> {
  final TextEditingController _messageController = TextEditingController();
  XFile? _selectedImage;
  Uint8List? _webImageBytes;

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      if (kIsWeb) {
        final bytes = await image.readAsBytes();
        setState(() {
          _webImageBytes = bytes;
          _selectedImage = image;
        });
      } else {
        setState(() {
          _selectedImage = image;
        });
      }
    }
  }

  void _sendMessage() {
    final message = _messageController.text.trim();
    widget.onSendMessage(message, _selectedImage);
    setState(() {
      _messageController.clear();
      _selectedImage = null;
      _webImageBytes = null; 
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          if (_selectedImage != null)
            Row(
              children: [
                kIsWeb
                    ? Image.memory(
                        _webImageBytes!,
                        width: 50,
                        height: 50,
                        fit: BoxFit.cover,
                      ) 
                    : Image.file(
                        File(_selectedImage!.path),
                        width: 50,
                        height: 50,
                        fit: BoxFit.cover,
                      ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () {
                    setState(() {
                      _selectedImage = null;
                      _webImageBytes = null; 
                    });
                  },
                ),
              ],
            ),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _messageController,
                  decoration: InputDecoration(
                    hintText: AppLocalizations.of(context)!.sendAMessage,
                    border: const OutlineInputBorder(),
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.image),
                onPressed: _pickImage,
              ),
              IconButton(
                icon: const Icon(Icons.send),
                onPressed: _sendMessage,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
