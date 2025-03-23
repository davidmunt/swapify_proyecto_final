import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:swapify/presentation/blocs/position/position_bloc.dart';
import 'package:swapify/presentation/blocs/position/position_event.dart';
import 'package:swapify/presentation/blocs/product/product_bloc.dart';
import 'package:swapify/presentation/blocs/product/product_event.dart';
import 'package:swapify/presentation/blocs/product_category/product_category_bloc.dart';
import 'package:swapify/presentation/blocs/product_category/product_category_event.dart';
import 'package:swapify/presentation/blocs/product_category/product_category_state.dart';
import 'package:swapify/presentation/blocs/user/user_bloc.dart';

class FiltrarProductosWidget extends StatefulWidget {
  final Function(String? searchTerm, double? minPrice, double? maxPrice, double? proximity, int? categoryId, String criteria, String direction, bool isFree) onApplyFilters;

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
  String? selectedOrder;
  String? selectedDirection;
  bool isFree = false;

  @override
  void initState() {
    super.initState();
    context.read<ProductCategoryBloc>().add(GetProductCategoryButtonPressed());
    final productBloc = context.read<ProductBloc>().state;
    searchController.text = productBloc.currentSearchTerm ?? '';
    minPriceController.text = productBloc.currentMinPrice?.toString() ?? '';
    maxPriceController.text = productBloc.currentMaxPrice?.toString() ?? '';
    isFree = productBloc.isFree ?? false;
    proximityController.text = productBloc.currentProximity?.toString() ?? '';
    selectedCategoryId = productBloc.currentCategoryId;
    selectedOrder = productBloc.currentSortCriteria;
    if (selectedOrder == null || selectedOrder!.isEmpty) {
      selectedOrder = "sinOrden";
    }
    selectedDirection = productBloc.currentSortDirection;
    if (selectedDirection == null || selectedDirection!.isEmpty) {
      selectedDirection = "asc"; 
    }
    final positionState = context.read<PositionBloc>().state;
    if (positionState.latitude == null || positionState.longitude == null) {
      context.read<PositionBloc>().add(GetPositionButtonPressed());
    }
  }

  bool _esNumero(String value) {
    final number = double.tryParse(value);
    return number != null && number >= 0;
  }

  @override
  Widget build(BuildContext context) {
    final userId = context.read<UserBloc>().state.user!.id;
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(AppLocalizations.of(context)!.filter, style: const TextStyle(
              fontSize: 22, 
              fontWeight: FontWeight.bold, 
              color: Colors.black, 
            )),
            const SizedBox(height: 15),
            Text(AppLocalizations.of(context)!.search),
            const SizedBox(height: 8),
            TextField(
              controller: searchController,
              decoration: InputDecoration(
                border: const OutlineInputBorder(),
                hintText: AppLocalizations.of(context)!.enterSearchTerm,
              ),
            ),
            const SizedBox(height: 12),
            Text(AppLocalizations.of(context)!.rangePrice),
            if (isFree != true)
              const SizedBox(height: 8),
            if (isFree != true)
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
                            Padding(
                              padding: const EdgeInsets.only(left: 16), 
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start, 
                                children: [
                                  Checkbox(
                                    value: isFree,
                                    onChanged: (bool? newValue) {
                                      setState(() {
                                        isFree = newValue ?? false;
                                        if (isFree) {
                                          maxPriceController.text = '0.00';
                                          minPriceController.text = '0.00';
                                        }
                                      });
                                    },
                                  ),
                                  const SizedBox(width: 5), 
                                  Text(
                                    AppLocalizations.of(context)!.free,
                                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                                  ),
                                ],
                              ),
                            ),
            const SizedBox(height: 12),
            Text(AppLocalizations.of(context)!.productCategory),
            const SizedBox(height: 8),
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
            const SizedBox(height: 15),
            Text(AppLocalizations.of(context)!.rangeProximity),
            const SizedBox(height: 15),
            TextField(
              controller: proximityController,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: InputDecoration(
                border: const OutlineInputBorder(),
                labelText: AppLocalizations.of(context)!.proximity,
              ),
            ),
            const SizedBox(height: 25),
            Text(AppLocalizations.of(context)!.order, style: const TextStyle(
              fontSize: 22, 
              fontWeight: FontWeight.bold, 
              color: Colors.black, 
            )),
            const SizedBox(height: 15),
            Text(AppLocalizations.of(context)!.orderBy),
            const SizedBox(height: 8),
            DropdownButtonFormField<String>(
              value: selectedOrder,
              items: [
                DropdownMenuItem(value: "sinOrden", child: Text("Sin orden")),
                DropdownMenuItem(value: "fecha", child: Text(AppLocalizations.of(context)!.dateUpload)),
                DropdownMenuItem(value: "distancia", child: Text(AppLocalizations.of(context)!.distance)),
                DropdownMenuItem(value: "precio", child: Text(AppLocalizations.of(context)!.price)),
              ],
              onChanged: (value) {
                setState(() {
                  selectedOrder = value;
                  errorMessage = null;
                });
              },
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: AppLocalizations.of(context)!.criterion,
              ),
            ),
            const SizedBox(height: 16),
            Text(AppLocalizations.of(context)!.direction),
            const SizedBox(height: 8),
            DropdownButtonFormField<String>(
              value: selectedDirection != "asc" && selectedDirection != "desc" ? "asc" : selectedDirection,
              items: [
                DropdownMenuItem(value: "asc", child: Text(AppLocalizations.of(context)!.ascending)),
                DropdownMenuItem(value: "desc", child: Text(AppLocalizations.of(context)!.descending)),
              ],
              onChanged: (value) {
                setState(() {
                  selectedDirection = value;
                  errorMessage = null;
                });
              },
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: AppLocalizations.of(context)!.order,
              ),
            ),
            const SizedBox(height: 16),
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
                    context.read<ProductBloc>().add(ResetFiltersButtonPressed(userId: userId));
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
                    if (double.tryParse(proximityController.text) == 0) {
                      setState(() {
                        errorMessage = "No puedes poner la proximidad en 0 Km";
                      });
                      return;
                    }
                    if (double.tryParse(proximityController.text)! > (40075 / 2)) {
                      setState(() {
                        errorMessage = "La proximidad no puede superar los ${40075 / 2} Km";
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
                    String finalOrder = selectedOrder ?? "sinOrden"; 
                    String finalDirection = selectedDirection ?? "asc"; 
                    if (finalOrder == "sinOrden") {
                      finalDirection = "sinOrden";
                    }
                    widget.onApplyFilters(
                      searchController.text.isEmpty ? null : searchController.text,
                      minPrice,
                      maxPrice,
                      proximity,
                      selectedCategoryId,
                      finalOrder,
                      finalDirection,
                      isFree,
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
