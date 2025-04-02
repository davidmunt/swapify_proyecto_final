import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

//widget para introducir numeros para los precios en los formularios
class WidgetTextoPrecio extends StatelessWidget {
  final String texto;
  final TextEditingController controller;

  const WidgetTextoPrecio({
    super.key,
    required this.texto,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 25),
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 178, 178, 178),
        borderRadius: BorderRadius.circular(12),
      ),
      child: TextField(
        controller: controller,
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        inputFormatters: [
          FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
        ],
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: texto,
          prefixIcon: const Icon(Icons.attach_money),
        ),
      ),
    );
  }
}
