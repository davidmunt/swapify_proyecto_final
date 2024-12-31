import 'package:flutter/material.dart';

class WidgetFechaNacimiento extends StatefulWidget {
  final DateTime? selectedDate;
  final Function(DateTime?) onDateSelected;

  const WidgetFechaNacimiento({
    super.key,
    required this.selectedDate,
    required this.onDateSelected,
  });

  @override
  State<WidgetFechaNacimiento> createState() => _WidgetFechaNacimientoState();
}

class _WidgetFechaNacimientoState extends State<WidgetFechaNacimiento> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        final DateTime? pickedDate = await showDatePicker(
          context: context,
          initialDate: widget.selectedDate ?? DateTime.now(),
          firstDate: DateTime(1900),
          lastDate: DateTime.now(),
        );
        if (pickedDate != null) {
          widget.onDateSelected(pickedDate);
        }
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 25),
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 10),
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 178, 178, 178),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            const Icon(Icons.cake, color: Colors.black54),
            const SizedBox(width: 16),
            Text(
              widget.selectedDate == null
              ? "Selecciona tu fecha de nacimiento"
              : "${widget.selectedDate!.day}/${widget.selectedDate!.month}/${widget.selectedDate!.year}",
              style: const TextStyle(fontSize: 16, color: Colors.black54),
            ),
          ],
        ),
      ),
    );
  }
}