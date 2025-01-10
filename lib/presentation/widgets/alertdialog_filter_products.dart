import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:swapify/presentation/blocs/product_category/product_category_bloc.dart';
import 'package:swapify/presentation/blocs/product_category/product_category_event.dart';
import 'package:swapify/presentation/blocs/product_category/product_category_state.dart';

class FiltrarProductosWidget extends StatefulWidget {
  final Function(String? searchTerm, double? minPrice, double? maxPrice, double? proximity, int? categoryId) onApplyFilters;

  const FiltrarProductosWidget({super.key, required this.onApplyFilters});

  @override
  State<FiltrarProductosWidget> createState() => _FiltrarProductosState();
}

class _FiltrarProductosState extends State<FiltrarProductosWidget> {
  final TextEditingController searchController = TextEditingController();
  final TextEditingController minPriceController = TextEditingController();
  final TextEditingController maxPriceController = TextEditingController();
  final TextEditingController proximityController = TextEditingController();

  int? selectedCategoryId;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    context.read<ProductCategoryBloc>().add(GetProductCategoryButtonPressed());
  }

  bool _esNumero(String value) {
    final number = double.tryParse(value);
    return number != null && number >= 0;
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Busqueda:"),
            TextField(
              controller: searchController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: "Introduce un termino de busqueda",
              ),
            ),
            const SizedBox(height: 12),
            const Text("Rango de precio:"),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: minPriceController,
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: "Min.",
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: TextField(
                    controller: maxPriceController,
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: "Max.",
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            const Text("Categoria del producto:"),
            BlocBuilder<ProductCategoryBloc, ProductCategoryState>(
              builder: (context, state) {
                if (state.isLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state.productCategories != null) {
                  final categories = state.productCategories!;
                  return DropdownButtonFormField<int>(
                    value: selectedCategoryId,
                    items: categories.map((category) {
                      return DropdownMenuItem<int>(
                        value: category.idCategoryProduct,
                        child: Text(category.name),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedCategoryId = value;
                      });
                    },
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: "Selecciona una categoria",
                    ),
                  );
                } else {
                  return const Text("No se pudieron cargar las categorias.");
                }
              },
            ),
            const SizedBox(height: 12),
            const Text("Rango de proximidad (km):"),
            TextField(
              controller: proximityController,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: "Proximidad",
              ),
            ),
            const SizedBox(height: 12),
            if (errorMessage != null)
              Text(
                errorMessage!,
                style: const TextStyle(color: Colors.red),
              ),
            const SizedBox(height: 12),
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
                    setState(() {
                      errorMessage = null;
                    });
                    if (minPriceController.text.isNotEmpty && !_esNumero(minPriceController.text)) {
                      setState(() {
                        errorMessage = "El precio mínimo debe ser un número positivo.";
                      });
                      return;
                    }
                    if (maxPriceController.text.isNotEmpty && !_esNumero(maxPriceController.text)) {
                      setState(() {
                        errorMessage = "El precio maximo tiene que ser un numero (positivo).";
                      });
                      return;
                    }
                    if (proximityController.text.isNotEmpty && !_esNumero(proximityController.text)) {
                      setState(() {
                        errorMessage = "La proximidad debe ser un numero (positivo).";
                      });
                      return;
                    }
                    final double? minPrice = minPriceController.text.isNotEmpty ? double.tryParse(minPriceController.text) : null;
                    final double? maxPrice = maxPriceController.text.isNotEmpty ? double.tryParse(maxPriceController.text) : null;
                    final double? proximity = proximityController.text.isNotEmpty ? double.tryParse(proximityController.text) : null;
                    if (minPrice != null && maxPrice != null && minPrice > maxPrice) {
                      setState(() {
                        errorMessage = "El precio minimo no puede ser mayor al precio maximo.";
                      });
                      return;
                    }
                    widget.onApplyFilters(
                      searchController.text.isEmpty ? null : searchController.text,
                      minPrice,
                      maxPrice,
                      proximity,
                      selectedCategoryId,
                    );
                    Navigator.of(context).pop();
                  },
                  child: const Text("Filtrar"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
