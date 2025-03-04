import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:swapify/presentation/blocs/position/position_bloc.dart';
import 'package:swapify/presentation/blocs/position/position_state.dart';
import 'package:swapify/presentation/blocs/product/product_bloc.dart';
import 'package:swapify/presentation/blocs/product/product_event.dart';
import 'package:swapify/presentation/blocs/product/product_state.dart';
import 'package:swapify/presentation/blocs/user/user_bloc.dart';
import 'package:swapify/presentation/blocs/user/user_state.dart';
import 'package:swapify/presentation/widgets/drawer.dart';

class LikeProductsScreen extends StatefulWidget {
  const LikeProductsScreen({super.key});

  @override
  State<LikeProductsScreen> createState() => _LikeProductsScreenState();
}

class _LikeProductsScreenState extends State<LikeProductsScreen> {

  @override
  Widget build(BuildContext context) {
    final userId = context.read<UserBloc>().state.user!.id;
    final productBloc = context.read<ProductBloc>();
    if (productBloc.state.youreLikedProducts == null) {
      productBloc.add(GetYoureLikedProductsButtonPressed(userId: userId));
    }
    final baseUrl = dotenv.env['BASE_API_URL'] ?? 'http://localhost:3000';
    return BlocBuilder<PositionBloc, PositionState>(
  builder: (context, positionState) {
    if (positionState.isLoading) {
      return const Center(child: CircularProgressIndicator());
    } else if (positionState.latitude != null && positionState.longitude != null) {
      return Scaffold(
      appBar: AppBar(
        title: const Text("Swapify"),
      ),
      body: BlocBuilder<UserBloc, UserState>(
        builder: (context, userState) {
          if (userState.isLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (userState.errorMessage == null && userState.user != null) {
            final userId = userState.user!.id;
            return BlocBuilder<ProductBloc, ProductState>(
              builder: (context, productState) {
                final products = productState.youreLikedProducts?.where((p) => p.userId != userId && p.idSaleStateProduct == 1 && p.likes.contains(userId)).toList() ?? [];
                if (productState.isLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (products.isEmpty) {
                  return Center(
                    child: Text(AppLocalizations.of(context)!.noProductsAvailable),
                  );
                }
                return SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Text(
                          AppLocalizations.of(context)!.availableProducts,
                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ),
                      const Divider(color: Color.fromARGB(255, 84, 84, 84)),
                      ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: products.length,
                        itemBuilder: (context, index) {
                          final product = products[index];
                          final bool isLiked = product.likes.contains(userId);
                          return GestureDetector(
                            onTap: () {
                              context.push(
                                '/product',
                                extra: {
                                  'id': product.productId,
                                  'marca': product.productBrand,
                                  'modelo': product.productModel,
                                  'descripcion': product.description,
                                  'precio': product.price,
                                  'categoria': product.idCategoryProduct,
                                  'estado': product.idStateProduct,
                                  'fecha': product.createdAt,
                                  'latitudeCreated': product.latitudeCreated,
                                  'longitudeCreated': product.longitudeCreated,
                                  'nameCityCreated': product.nameCityCreated,
                                  'userId': product.userId,
                                  'images': product.images.map((image) => image.path).toList(),
                                },
                              );
                            },
                            child: Card(
                              margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                              elevation: 3,
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const SizedBox(width: 16),
                                    Container(
                                      padding: const EdgeInsets.symmetric(vertical: 16),
                                      child: Image.network(
                                        '$baseUrl${product.images.first.path}',
                                        width: 125,
                                        height: 125,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    const SizedBox(width: 16),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(product.productBrand,
                                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                                          const SizedBox(height: 4),
                                          Text(product.productModel,
                                            style: const TextStyle(fontSize: 14, color: Colors.black54)),
                                          const SizedBox(height: 8),
                                          Text(product.description,
                                            style: const TextStyle(fontSize: 14, color: Colors.black54),
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis),
                                          const SizedBox(height: 8),
                                          Text(AppLocalizations.of(context)!.productPrice(product.price),
                                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.green)),
                                          const SizedBox(height: 8),
                                          Text(AppLocalizations.of(context)!.dateCreated(product.createdAt),
                                            style: const TextStyle(fontSize: 12, color: Colors.grey)),
                                        ],
                                      ),
                                    ),
                                    IconButton(
                                      icon: Icon(isLiked ? Icons.favorite : Icons.favorite_border, color: Colors.red),
                                      onPressed: () {
                                        if (isLiked) {
                                          context.read<ProductBloc>().add(UnlikeProductButtonPressed(userId: userId, productId: product.productId, userLatitude: positionState.latitude ?? 0.000000, userLongitude: positionState.longitude ?? 0.000000));
                                        } else {
                                          context.read<ProductBloc>().add(LikeProductButtonPressed(userId: userId, productId: product.productId, userLatitude: positionState.latitude ?? 0.000000, userLongitude: positionState.longitude ?? 0.000000));
                                        }
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                );
              },
            );
          } else {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(AppLocalizations.of(context)!.errorComeLater),
                ],
              ),
            );
          }
        },
      ),
      drawer: const DrawerWidget(),
        );
        } else {
      return Center(child: Text(AppLocalizations.of(context)!.errorUbication));
    }
  },
);
  }
}
