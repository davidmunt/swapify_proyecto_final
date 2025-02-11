import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter/foundation.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:swapify/presentation/blocs/product/product_bloc.dart';
import 'package:swapify/presentation/blocs/product/product_event.dart';
import 'package:swapify/presentation/blocs/product/product_state.dart';
import 'package:swapify/presentation/blocs/user/user_bloc.dart';
import 'package:swapify/presentation/blocs/user/user_event.dart';
import 'package:swapify/presentation/blocs/user/user_state.dart';
import 'package:swapify/presentation/widgets/alertdialog_filter_products.dart';
import 'package:swapify/presentation/widgets/alertdialog_order_products.dart';
import 'package:swapify/presentation/widgets/drawer.dart';

class SearchProductsScreen extends StatefulWidget {
  const SearchProductsScreen({super.key});

  @override
  State<SearchProductsScreen> createState() => _SearchProductsScreenState();
}

class _SearchProductsScreenState extends State<SearchProductsScreen> {
    bool _hasCheckedToken = false;

  Future<void> _checkAndUpdateFCMToken(UserState userState) async {
    if (_hasCheckedToken || kIsWeb) return; 
    try {
      String? newToken = await FirebaseMessaging.instance.getToken();
      if (newToken != null && mounted && userState.user != null) {
        String? userMessageToken = userState.user!.tokenNotifications;
        if (userMessageToken == null || userMessageToken != newToken) {
          context.read<UserBloc>().add(SaveUserNotificationTokenButtonPressed(userId: userState.user!.id, notificationToken: newToken));
        }
      }
    } catch (e) {
      debugPrint("Error al obtener el token de Firebase Messaging: $e");
    }
    _hasCheckedToken = true;
  }

  @override
  Widget build(BuildContext context) {
    final productBloc = context.read<ProductBloc>();
    productBloc.add(GetProductsButtonPressed());
    final baseUrl = dotenv.env['BASE_API_URL'] ?? 'http://localhost:3000';

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
            _checkAndUpdateFCMToken(userState);
            final userId = userState.user!.id;
            return BlocBuilder<ProductBloc, ProductState>(
              builder: (context, productState) {
                final products = productState.products?.where((p) => p.userId != userId && p.idSaleStateProduct == 1).toList() ?? [];
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
                                          context.read<ProductBloc>().add(UnlikeProductButtonPressed(userId: userId, productId: product.productId));
                                        } else {
                                          context.read<ProductBloc>().add(LikeProductButtonPressed(userId: userId, productId: product.productId));
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
      floatingActionButton: Align(
        alignment: Alignment.bottomRight,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            BlocBuilder<ProductBloc, ProductState>(
              builder: (context, state) {
                final filterCount = [
                  if (state.currentSearchTerm?.isNotEmpty ?? false) true,
                  if (state.currentMinPrice != null) true,
                  if (state.currentMaxPrice != null) true,
                  if (state.currentProximity != null) true,
                  if (state.currentCategoryId != null) true,
                ].length;
                return Stack(
                  children: [
                    FloatingActionButton(
                      onPressed: () async {
                        final position = await Geolocator.getCurrentPosition();
                        showModalBottomSheet(
                          context: context,
                          builder: (context) {
                            return FiltrarProductosWidget(
                              onApplyFilters: (searchTerm, minPrice, maxPrice, proximity, categoryId) {
                                context.read<ProductBloc>().add(FilterProductsButtonPressed(
                                  searchTerm: searchTerm,
                                  minPrice: minPrice,
                                  maxPrice: maxPrice,
                                  proximity: proximity,
                                  userLatitude: position.latitude,
                                  userLongitude: position.longitude,
                                  categoryId: categoryId,
                                ));
                              },
                            );
                          },
                        );
                      },
                      child: const Icon(Icons.filter_alt),
                    ),
                    if (filterCount > 0)
                      Positioned(
                        right: 0, top: 0,
                        child: CircleAvatar(
                          radius: 10,
                          backgroundColor: Colors.red,
                          child: Text(filterCount.toString(), style: const TextStyle(color: Colors.white, fontSize: 12)),
                        ),
                      ),
                  ],
                );
              },
            ),
            const SizedBox(height: 8),
            BlocBuilder<ProductBloc, ProductState>(
              builder: (context, state) {
                final hasSorting = state.currentSortCriteria != null && state.currentSortDirection != null;
                return Stack(
                  children: [
                    FloatingActionButton(
                      onPressed: () async {
                        final position = await Geolocator.getCurrentPosition();
                        showModalBottomSheet(
                          context: context,
                          builder: (context) {
                            return OrdenarProductosWidget(
                              onApplySort: (criteria, direction) {
                                context.read<ProductBloc>().add(SortProductsButtonPressed(
                                  criteria: criteria,
                                  direction: direction,
                                  userLatitude: position.latitude,
                                  userLongitude: position.longitude,
                                ));
                              },
                            );
                          },
                        );
                      },
                      child: const Icon(Icons.sort),
                    ),
                    if (hasSorting)
                      const Positioned(
                        right: 0,
                        top: 0,
                        child: CircleAvatar(
                          radius: 10,
                          backgroundColor: Colors.red,
                          child: Text("1", style: TextStyle(color: Colors.white, fontSize: 12)),
                        ),
                      ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
      drawer: const DrawerWidget(),
    );
  }
}
