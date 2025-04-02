import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:image_picker/image_picker.dart';
import 'package:swapify/presentation/blocs/product/product_bloc.dart';
import 'package:swapify/presentation/blocs/product/product_event.dart';
import 'package:swapify/presentation/blocs/product/product_state.dart';
import 'package:swapify/presentation/blocs/user/user_bloc.dart';
import 'package:swapify/presentation/blocs/user/user_state.dart';
import 'package:swapify/presentation/widgets/drawer.dart';

//pagina que muestra tus productos, los puedes editar o crear nuevos
class MyProductsScreen extends StatefulWidget {
  const MyProductsScreen({super.key});

  @override
  State<MyProductsScreen> createState() => _MyProductsScreenState();
}

class _MyProductsScreenState extends State<MyProductsScreen> {
  @override
  void initState() {
    super.initState();
    final userId = context.read<UserBloc>().state.user!.id;
    final token = context.read<UserBloc>().state.token ?? '';
    context.read<ProductBloc>().add(GetYoureProductsButtonPressed(userId: userId, token: token));
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
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (userState.errorMessage == null && userState.user != null) {
            final userId = userState.user!.id;
            final baseUrl = dotenv.env['BASE_API_URL'] ?? 'http://localhost:3000';
            return BlocBuilder<ProductBloc, ProductState>(
              builder: (context, productState) {
                if (productState.isLoading) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (productState.youreProducts == null) {
                  return const SizedBox();
                }
                if (productState.errorMessage != null) {
                  return Center(child: Text(productState.errorMessage!));
                }
                final userProducts = productState.youreProducts!.where((product) => product.userId == userId && product.idSaleStateProduct != 4).toList();
                if (userProducts.isEmpty) {
                  return Center(
                    child: Text(AppLocalizations.of(context)!.youDontHaveProducts, style: const TextStyle(fontSize: 16)),
                  );
                }
                return SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Text(AppLocalizations.of(context)!.youreProducts,
                            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      ),
                      const Divider(color: Color.fromARGB(255, 84, 84, 84)),
                      ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: userProducts.length,
                        itemBuilder: (context, index) {
                          final product = userProducts[index];
                          return GestureDetector(
                            onTap: () {
                              context.push(
                                '/create_modify_product',
                                extra: {
                                  'productId': product.productId,
                                  'marca': product.productBrand,
                                  'modelo': product.productModel,
                                  'descripcion': product.description,
                                  'precio': product.price,
                                  'categoria': product.idCategoryProduct,
                                  'estado': product.idStateProduct,
                                  'estadoVenta': product.idSaleStateProduct,
                                  'images': product.images.map((image) => XFile(image.path)).toList(),
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
                                      child: product.images.isNotEmpty
                                          ? Image.network(
                                              '$baseUrl${product.images.first.path}',
                                              width: 125,
                                              height: 125,
                                              fit: BoxFit.cover,
                                            )
                                          : Container(
                                              width: 125,
                                              height: 125,
                                              color: Colors.grey[300],
                                              child: const Icon(Icons.image_not_supported, size: 50, color: Colors.grey),
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
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.bold, fontSize: 14, color: Colors.green)),
                                          const SizedBox(height: 8),
                                          Text(AppLocalizations.of(context)!.dateCreated(product.createdAt),
                                              style: const TextStyle(fontSize: 12, color: Colors.grey)),
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.push('/create_modify_product');
        },
        child: const Icon(Icons.add),
      ),
      drawer: const DrawerWidget(),
    );
  }
}
