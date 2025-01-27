import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:swapify/presentation/blocs/product/product_bloc.dart';
import 'package:swapify/presentation/blocs/product/product_event.dart';

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
  void initState() {
    super.initState();
    final productBloc = context.read<ProductBloc>().state;

    // Restaurar valores del estado actual
    selectedOrder = productBloc.currentSortCriteria;
    selectedDirection = productBloc.currentSortDirection;
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(AppLocalizations.of(context)!.orderProducts, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            Text(AppLocalizations.of(context)!.orderBy),
            DropdownButtonFormField<String>(
              value: selectedOrder,
              items: [
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
            DropdownButtonFormField<String>(
              value: selectedDirection,
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
              Text(errorMessage!, style: const TextStyle(color: Colors.red)),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton(
                  onPressed: () {
                    context.read<ProductBloc>().add(ResetSortButtonPressed());
                    Navigator.of(context).pop(); 
                  },
                  child: Text(AppLocalizations.of(context)!.resetOrder),
                ),
                TextButton(
                  onPressed: () {
                    if (selectedOrder == null || selectedDirection == null) {
                      setState(() {
                        errorMessage = AppLocalizations.of(context)!.selectTheFieldsApplySorting;
                      });
                    } else {
                      widget.onApplySort(selectedOrder!, selectedDirection!);
                      Navigator.of(context).pop();
                    }
                  },
                  child: Text(AppLocalizations.of(context)!.order),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
