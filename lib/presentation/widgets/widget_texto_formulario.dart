import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class WidgetTextoFormulario extends StatelessWidget {
  final String texto;
  final Icon iconoHint;
  final IconData? icon;
  final void Function()? onPressed;
  final bool obscureText;
  final TextEditingController? controller;

  const WidgetTextoFormulario({
    super.key,
    required this.texto,
    required this.iconoHint,
    this.icon,
    this.onPressed,
    this.obscureText = false,
    this.controller,
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
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: TextField(
              controller: controller,
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: texto,
                prefixIcon: iconoHint,
              ),
              obscureText: obscureText,
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9@._]')),
                LengthLimitingTextInputFormatter(100), // Limitar caracteres si es necesario
              ],
            ),
          ),
          IconButton(onPressed: onPressed, icon: Icon(icon))
        ],
      ),
    );
  }
}
