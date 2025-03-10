import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:swapify/presentation/blocs/product/product_bloc.dart';
import 'package:swapify/presentation/blocs/product/product_event.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:swapify/presentation/blocs/product/product_state.dart';
import 'package:swapify/presentation/blocs/user/user_bloc.dart';
import 'package:swapify/presentation/blocs/user/user_state.dart';

class YoureEnvolvmentScreen extends StatefulWidget {
  const YoureEnvolvmentScreen({super.key});

  @override
  State<YoureEnvolvmentScreen> createState() => _YoureEnvolvmentScreenState();
}

class _YoureEnvolvmentScreenState extends State<YoureEnvolvmentScreen> {
  @override
  void initState() {
    super.initState();
    final userId = context.read<UserBloc>().state.user!.id;
    final productBloc = context.read<ProductBloc>();
    productBloc.add(GetYoureEnvolvmentProductsButtonPressed(userId: userId));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Swapify"),
      ),
      body: BlocBuilder<UserBloc, UserState>(
        builder: (context, userState) {
          if (userState.isLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (userState.user != null && userState.errorMessage == null) {
            final userId = userState.user!.id;
            final baseUrl = dotenv.env['BASE_API_URL'] ?? 'http://localhost:3000';
            return BlocBuilder<ProductBloc, ProductState>(
              builder: (context, productState) {
                final products = productState.youreEnvolvmentProducts ?? [];
                if (productState.isLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (products.isEmpty) {
                  return Center(
                    child: Text(AppLocalizations.of(context)!.noProductsAvailable),
                  );
                }
                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: products.length,
                  itemBuilder: (context, index) {
                    final product = products[index];
                    final bool isBuyer = product.buyerId == userId;
                    final String transactionText;
                    if (isBuyer) {
                      transactionText = AppLocalizations.of(context)!.youHadBoughtTheProduct;
                    } else {
                      transactionText = AppLocalizations.of(context)!.youHadSoldTheProduct;
                    }
                    final Color transactionColor = isBuyer ? Colors.blue : Colors.green;
                    var priceColor = isBuyer ? Colors.red : Colors.green; 
                    var pricePrefix = isBuyer ? "-" : "+"; 
                    if (product.price == 0) {
                      priceColor = Colors.orange;
                      pricePrefix = "";
                    }
                    return Card(
                      margin: const EdgeInsets.only(bottom: 16),
                      elevation: 3,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
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
                                  Row(
                                    children: [
                                      Text(
                                        product.productBrand,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        product.productModel,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  if (product.productExangedId == null)
                                    Text(
                                      product.price == 0
                                        ? AppLocalizations.of(context)!.free
                                        : "$pricePrefix${AppLocalizations.of(context)!.productPrice(product.price)}",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                        color: priceColor,
                                      ),
                                    ),
                                  const SizedBox(height: 8),
                                  Text(
                                    product.productExangedId != null
                                      ? AppLocalizations.of(context)!.dateSwaped(product.lastUpdated)
                                      : isBuyer
                                          ? AppLocalizations.of(context)!.dateBought(product.createdAt)
                                          : AppLocalizations.of(context)!.dateSold(product.createdAt),
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 4,
                                      horizontal: 8,
                                    ),
                                    decoration: BoxDecoration(
                                      color: transactionColor.withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(8),
                                      border: Border.all(color: transactionColor),
                                    ),
                                    child: Text(
                                      transactionText,
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                        color: transactionColor,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            );
          } else {
            return Center(
              child: Text(AppLocalizations.of(context)!.errorObtainingUserInfoChat),
            );
          }
        },
      ),
    );
  }
}