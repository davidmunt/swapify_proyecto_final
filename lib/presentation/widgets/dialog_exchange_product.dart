import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:swapify/presentation/blocs/product/product_bloc.dart';
import 'package:swapify/presentation/blocs/product/product_event.dart';
import 'package:swapify/presentation/blocs/product/product_state.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:swapify/presentation/blocs/user/user_bloc.dart';

//alert para confirmar el intercambio de un producto
class ExchangeProductDialog extends StatefulWidget {
  const ExchangeProductDialog({super.key});

  @override
  State<ExchangeProductDialog> createState() => _ExchangeProductDialogState();
}

class _ExchangeProductDialogState extends State<ExchangeProductDialog> {

  @override
  void initState() {
    super.initState();
    final token = context.read<UserBloc>().state.token;
    final userId = context.read<UserBloc>().state.user!.id;
    final productBloc = context.read<ProductBloc>();
    productBloc.add(GetYoureProductsButtonPressed(userId: userId, token: token ?? ''));
  }

  @override 
  Widget build(BuildContext context) {
    final baseUrl = dotenv.env['BASE_API_URL'] ?? 'http://localhost:3000';

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min, 
          children: [
            BlocBuilder<ProductBloc, ProductState>(
              builder: (context, productState) {
                if (productState.isLoading || productState.youreProducts == null) {
                  return const SizedBox(
                    height: 200, child: Center(child: CircularProgressIndicator()),
                  );
                }
                final products = productState.youreProducts!.where((p) => p.idSaleStateProduct == 1).toList();
                if (products.isEmpty) {
                  return const SizedBox(
                    height: 200,
                    child: Center(child: Text("No tienes productos disponibles")),
                  );
                }
                return Expanded(
                  child: ListView.builder(
                    itemCount: products.length,
                    itemBuilder: (context, index) {
                      final product = products[index];
                      return GestureDetector(
                        onTap: () {
                          Navigator.pop(context, {
                            'idProduct': product.productId,
                            'productImage': '${product.images.first.path}'
                          });
                        },
                        child: Card(
                          margin: const EdgeInsets.symmetric(vertical: 8),
                          elevation: 3,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Row(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Image.network(
                                    '$baseUrl${product.images.first.path}',
                                    width: 100,
                                    height: 100,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "${product.productBrand} ${product.productModel}",
                                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        AppLocalizations.of(context)!.productPrice(product.price),
                                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.green),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
            const SizedBox(height: 12), 
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(AppLocalizations.of(context)!.cancel),
            ),
          ],
        ),
      ),
    );
  }
}
