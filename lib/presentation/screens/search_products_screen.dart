import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:geolocator/geolocator.dart';
import 'package:swapify/domain/entities/product.dart';
import 'package:swapify/presentation/blocs/product/product_bloc.dart';
import 'package:swapify/presentation/blocs/product/product_event.dart';
import 'package:swapify/presentation/blocs/product/product_state.dart';
import 'package:swapify/presentation/blocs/user/user_bloc.dart';
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
  List<ProductEntity> _displayedProducts = [];

  Future<void> _applyFilters(BuildContext context, ProductBloc bloc) async {
    final position = await Geolocator.getCurrentPosition();
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return FiltrarProductosWidget(
          onApplyFilters: (searchTerm, minPrice, maxPrice, proximity, categoryId) { 
            bloc.add(FilterProductsButtonPressed(
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
  }

  void _applySorting(BuildContext context, ProductBloc bloc) async {
    final position = await Geolocator.getCurrentPosition();
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return OrdenarProductosWidget(
          onApplySort: (criteria, direction) {
            bloc.add(SortProductsButtonPressed(
              criteria: criteria,
              direction: direction,
              userLatitude: position.latitude, 
              userLongitude: position.longitude, 
            ));
          },
        );
      },
    );
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
            final userId = userState.user!.id;
            return BlocListener<ProductBloc, ProductState>(
              listener: (context, state) {
                if (state.filteredProducts != null || state.sortedProducts != null) {
                  setState(() {
                    _displayedProducts = state.sortedProducts ?? state.filteredProducts ?? state.products ?? [];
                  });
                }
              },
              child: BlocBuilder<ProductBloc, ProductState>(
                builder: (context, productState) {
                  final showProducts = _displayedProducts.isNotEmpty ? _displayedProducts : productState.products?.where((p) => p.userId != userId).toList() ?? [];
                  if (productState.isLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (showProducts.isEmpty) {
                    return const Center(
                      child: Text('No hay productos disponibles.'),
                    );
                  }
                  if (productState.filteredProducts != null && productState.filteredProducts!.isEmpty) {
                    return const Center(
                      child: Text('No hay productos disponibles con los filtros seleccionados.'),
                    );
                  }
                  return SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Padding(
                          padding: EdgeInsets.all(16.0),
                          child: Text("Productos disponibles : ", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                        ),
                        const Divider(color: Color.fromARGB(255, 84, 84, 84)),
                        ListView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: showProducts.length,
                          itemBuilder: (context, index) {
                            final product = showProducts[index];
                            final formattedDate = DateFormat('dd MMM yyyy').format(product.createdAt); 
                            final bool isLiked = product.likes.contains(userId);
                            return GestureDetector(
                              onTap: () {
                                context.go(
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
                                            Text(product.productBrand, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                                            const SizedBox(height: 4),
                                            Text(product.productModel, style: const TextStyle(fontSize: 14, color: Colors.black54)),
                                            const SizedBox(height: 8),
                                            Text(product.description, style: const TextStyle(fontSize: 14, color: Colors.black54), maxLines: 2, overflow: TextOverflow.ellipsis),
                                            const SizedBox(height: 8),
                                            Text("${product.price}€", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.green)),
                                            const SizedBox(height: 8),
                                            Text("Creado el: $formattedDate", style: const TextStyle(fontSize: 12, color: Colors.grey)),
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
              ),
            );
          } else {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text("Ha habido un error: ${userState.errorMessage}, intentalo mas tarde"),
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
            FloatingActionButton(
              onPressed: () => _applyFilters(context, productBloc),
              child: const Icon(Icons.filter_alt),
            ),
            const SizedBox(height: 8),
            FloatingActionButton(
              onPressed: () => _applySorting(context, productBloc),
              child: const Icon(Icons.sort),
            ),
          ],
        ),
      ),
      drawer: const DrawerWidget(),
    );
  }
}