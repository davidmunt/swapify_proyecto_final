import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:image_picker/image_picker.dart';
import 'package:swapify/presentation/blocs/product/product_bloc.dart';
import 'package:swapify/presentation/blocs/product/product_event.dart';
import 'package:swapify/presentation/blocs/product/product_state.dart';
import 'package:swapify/presentation/blocs/user/user_bloc.dart';
import 'package:swapify/presentation/blocs/user/user_state.dart';
import 'package:swapify/presentation/widgets/drawer.dart';

class MyProductsScreen extends StatefulWidget {
  const MyProductsScreen({super.key});

  @override
  State<MyProductsScreen> createState() => _MyProductsScreenState();
}

class _MyProductsScreenState extends State<MyProductsScreen> {
  @override
  Widget build(BuildContext context) {
    context.read<ProductBloc>().add(GetProductsButtonPressed());
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
                } else if (productState.products != null) {
                  final userProducts = productState.products!.where((product) => product.userId == userId).toList();
                  if (userProducts.isEmpty) {
                    return const Center(
                      child: Text('No tienes productos subidos.', style: TextStyle(fontSize: 16)),
                    );
                  }
                  return SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Padding(
                          padding: EdgeInsets.all(16.0),
                          child: Text("Estos son tus productos", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                        ),
                        const Divider(color: Color.fromARGB(255, 84, 84, 84)),
                        ListView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: userProducts.length,
                          itemBuilder: (context, index) {
                            final product = userProducts[index];
                            final formattedDate = DateFormat('dd MMM yyyy').format(product.createdAt);
                            return GestureDetector(
                              onTap: () {
                                context.go(
                                  '/create_modify_product',
                                  extra: {
                                    'productId': product.productId,
                                    'marca': product.productBrand,
                                    'modelo': product.productModel,
                                    'descripcion': product.description,
                                    'precio': product.price,
                                    'categoria': product.idCategoryProduct,
                                    'estado': product.idStateProduct,
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
                } else if (productState.errorMessage != null) {
                  return Center(
                    child: Text(productState.errorMessage!),
                  );
                } else {
                  return const Center(
                    child: Text('No tienes productos subidos.'),
                  );
                }
              },
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.go('/create_modify_product');
        },
        child: const Icon(Icons.add),
      ),
      drawer: const DrawerWidget(),
    );
  }
}
