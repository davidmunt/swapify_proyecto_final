import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class AlertShowImageChat extends StatelessWidget {
  final String imagenMostrar;

  const AlertShowImageChat({super.key, required this.imagenMostrar});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.all(10), 
      child: LayoutBuilder(
        builder: (context, constraints) {
          return Container(
            constraints: BoxConstraints(
              maxHeight: constraints.maxHeight * 0.9,
              maxWidth: constraints.maxWidth * 0.9,
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.network(
                "${dotenv.env['BASE_API_URL']}$imagenMostrar",
                fit: BoxFit.contain, 
              ),
            ),
          );
        },
      ),
    );
  }
}
