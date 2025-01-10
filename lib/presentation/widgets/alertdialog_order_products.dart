import 'package:flutter/material.dart';

class OrdenarProductosWidget extends StatefulWidget {
  final Function(String criteria, String direction) onApplySort;

  const OrdenarProductosWidget({super.key, required this.onApplySort});

  @override
  State<OrdenarProductosWidget> createState() => _OrdenarProductosState();
}

class _OrdenarProductosState extends State<OrdenarProductosWidget> {
  String? selectedOrder;
  String? selectedDirection;
  String? errorMessage;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Ordenar productos", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            const Text("Ordenar por:"),
            DropdownButtonFormField<String>(
              value: selectedOrder,
              items: const [
                DropdownMenuItem(value: "fecha", child: Text("Fecha de publicacion")),
                DropdownMenuItem(value: "distancia", child: Text("Distancia")),
                DropdownMenuItem(value: "precio", child: Text("Precio")),
              ],
              onChanged: (value) {
                setState(() {
                  selectedOrder = value;
                  errorMessage = null;
                });
              },
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: "Criterio",
              ),
            ),
            const SizedBox(height: 16),
            const Text("Direccion:"),
            DropdownButtonFormField<String>(
              value: selectedDirection,
              items: const [
                DropdownMenuItem(value: "asc", child: Text("Ascendente")),
                DropdownMenuItem(value: "desc", child: Text("Descendente")),
              ],
              onChanged: (value) {
                setState(() {
                  selectedDirection = value;
                  errorMessage = null; 
                });
              },
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: "Orden",
              ),
            ),
            const SizedBox(height: 16),
            if (errorMessage != null)
              Text(errorMessage!, style: const TextStyle(color: Colors.red)), 
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text("Cancelar"),
                ),
                TextButton(
                  onPressed: () {
                    if (selectedOrder == null || selectedDirection == null) {
                      setState(() {
                        errorMessage = "Selecciona los dos campos para aplicar el orden";
                      });
                    } else {
                      widget.onApplySort(selectedOrder!, selectedDirection!);
                      Navigator.of(context).pop();
                    }
                  },
                  child: const Text("Ordenar"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
