import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/foundation.dart';
import 'dart:typed_data';
import 'package:swapify/presentation/widgets/dialog_exchange_product.dart'; 

//widget que permite al usuario enviar mensajes, imagenes o propuestas de intercambio de producto dentro del chat
class SendMessageWidget extends StatefulWidget {
  final Function(String message, XFile? image, int? idProduct, String? productImage) onSendMessage;
  final String productOwnerId;
  final String userId;

  const SendMessageWidget({super.key, required this.onSendMessage, required this.productOwnerId, required this.userId});

  @override
  State<SendMessageWidget> createState() => _SendMessageWidgetState();
}

class _SendMessageWidgetState extends State<SendMessageWidget> {
  final TextEditingController _messageController = TextEditingController();
  XFile? _selectedImage;
  Uint8List? _webImageBytes;

  //muestra un dialogo para seleccionar un producto de intercambio y envia la propuesta si se selecciona uno
  Future<void> _sendExchangeProduct() async {
    final result = await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (context) => const ExchangeProductDialog(),
    );
    if (result != null) {
      widget.onSendMessage("", null, result['idProduct'] as int, result['productImage'] as String);
    }
  }

  //permite seleccionar una imagen desde la galeria y la guarda localmente o en memoria(web) para verla seleccionada o enviarla
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

  //envia el mensaje de texto o imagen seleccionada
  void _sendMessage() {
    final message = _messageController.text.trim();
    if (message.isNotEmpty || _selectedImage != null) {
      widget.onSendMessage(message, _selectedImage, null, null);
      setState(() {
        _messageController.clear();
        _selectedImage = null;
        _webImageBytes = null; 
      });
    }
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
                child: RawKeyboardListener(
                  focusNode: FocusNode(),
                  onKey: (event) {
                    if (kIsWeb &&
                        event.runtimeType == RawKeyDownEvent &&
                        event.logicalKey == LogicalKeyboardKey.enter) {
                      _sendMessage();
                    }
                  },
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(
                      hintText: AppLocalizations.of(context)!.sendAMessage,
                      border: const OutlineInputBorder(),
                    ),
                    onSubmitted: (_) {
                      if (kIsWeb) _sendMessage();
                    },
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.image),
                onPressed: _pickImage,
              ),
              if (widget.userId != widget.productOwnerId)
                IconButton(
                  icon: const Icon(Icons.sync_alt),
                  onPressed: _sendExchangeProduct,
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
