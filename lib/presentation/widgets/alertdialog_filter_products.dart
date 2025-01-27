import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:swapify/presentation/blocs/product/product_bloc.dart';
import 'package:swapify/presentation/blocs/product/product_event.dart';
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
    final productBloc = context.read<ProductBloc>().state;

    // Restaurar valores del estado actual
    searchController.text = productBloc.currentSearchTerm ?? '';
    minPriceController.text = productBloc.currentMinPrice?.toString() ?? '';
    maxPriceController.text = productBloc.currentMaxPrice?.toString() ?? '';
    proximityController.text = productBloc.currentProximity?.toString() ?? '';
    selectedCategoryId = productBloc.currentCategoryId;
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
            Text(AppLocalizations.of(context)!.search),
            TextField(
              controller: searchController,
              decoration: InputDecoration(
                border: const OutlineInputBorder(),
                hintText: AppLocalizations.of(context)!.enterSearchTerm,
              ),
            ),
            const SizedBox(height: 12),
            Text(AppLocalizations.of(context)!.rangePrice),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: minPriceController,
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    decoration: InputDecoration(
                      border: const OutlineInputBorder(),
                      labelText: AppLocalizations.of(context)!.min,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: TextField(
                    controller: maxPriceController,
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    decoration: InputDecoration(
                      border: const OutlineInputBorder(),
                      labelText: AppLocalizations.of(context)!.max,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(AppLocalizations.of(context)!.productCategory),
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
                    decoration: InputDecoration(
                      border: const OutlineInputBorder(),
                      hintText: AppLocalizations.of(context)!.selectCategory,
                    ),
                  );
                } else {
                  return Text(AppLocalizations.of(context)!.failedChargeCategories);
                }
              },
            ),
            const SizedBox(height: 12),
            Text(AppLocalizations.of(context)!.rangeProximity),
            TextField(
              controller: proximityController,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: InputDecoration(
                border: const OutlineInputBorder(),
                labelText: AppLocalizations.of(context)!.proximity,
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
                    context.read<ProductBloc>().add(ResetFiltersButtonPressed());
                    Navigator.of(context).pop();
                  },
                  child: Text(AppLocalizations.of(context)!.resetFilters),
                ),
                TextButton(
                  onPressed: () {
                    setState(() {
                      errorMessage = null;
                    });
                    if (minPriceController.text.isNotEmpty && !_esNumero(minPriceController.text)) {
                      setState(() {
                        errorMessage = AppLocalizations.of(context)!.errorMinPricePositive;
                      });
                      return;
                    }
                    if (maxPriceController.text.isNotEmpty && !_esNumero(maxPriceController.text)) {
                      setState(() {
                        errorMessage = AppLocalizations.of(context)!.errorMaxPricePositive;
                      });
                      return;
                    }
                    if (proximityController.text.isNotEmpty && !_esNumero(proximityController.text)) {
                      setState(() {
                        errorMessage = AppLocalizations.of(context)!.errorProximityPositive;
                      });
                      return;
                    }
                    final double? minPrice = minPriceController.text.isNotEmpty ? double.tryParse(minPriceController.text) : null;
                    final double? maxPrice = maxPriceController.text.isNotEmpty ? double.tryParse(maxPriceController.text) : null;
                    final double? proximity = proximityController.text.isNotEmpty ? double.tryParse(proximityController.text) : null;
                    if (minPrice != null && maxPrice != null && minPrice > maxPrice) {
                      setState(() {
                        errorMessage = AppLocalizations.of(context)!.errorPriceMinMoreMax;
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
                  child: Text(AppLocalizations.of(context)!.filter),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
