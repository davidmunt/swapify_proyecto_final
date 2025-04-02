import 'package:flutter/material.dart';

//WidgetDropdown para seleccionar la categoria, estado, estado de la venta
class WidgetDropdownCategory<T> extends StatelessWidget {
  final List<T> items;
  final int? selectedItemId;
  final void Function(int?) onChanged;
  final String hintText;
  final int Function(T) getId; 
  final String Function(T) displayText; 

  const WidgetDropdownCategory({
    super.key,
    required this.items,
    required this.selectedItemId,
    required this.onChanged,
    required this.hintText,
    required this.getId,
    required this.displayText,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8.0),
          border: Border.all(color: Colors.grey.shade400, width: 1.0),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 12.0),
        child: DropdownButton<int>(
          isExpanded: true,
          hint: Text(hintText),
          value: selectedItemId,
          onChanged: onChanged,
          items: items.map((item) {
            return DropdownMenuItem<int>(
              value: getId(item), 
              child: Text(displayText(item)), 
            );
          }).toList(),
          underline: const SizedBox(),
          icon: const Icon(Icons.arrow_drop_down, color: Colors.grey),
        ),
      ),
    );
  }
}
