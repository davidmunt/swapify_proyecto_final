import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:swapify/domain/entities/product_category.dart';
import 'package:swapify/domain/entities/product_state.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:swapify/injection.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:swapify/presentation/blocs/product/product_bloc.dart';
import 'package:swapify/presentation/blocs/product/product_event.dart';
import 'package:swapify/presentation/blocs/product/product_state.dart';
import 'package:swapify/presentation/blocs/product_category/product_category_bloc.dart';
import 'package:swapify/presentation/blocs/product_category/product_category_event.dart';
import 'package:swapify/presentation/blocs/product_category/product_category_state.dart';
import 'package:swapify/presentation/blocs/product_state/product_state_bloc.dart';
import 'package:swapify/presentation/blocs/product_state/product_state_event.dart';
import 'package:swapify/presentation/blocs/product_state/product_state_state.dart';
import 'package:swapify/presentation/widgets/drawer.dart';

class ProductScreen extends StatefulWidget {
  final int id;
  final String marca;
  final String modelo;
  final String descripcion;
  final double precio;
  final DateTime fecha;
  final int categoria;
  final int estado;
  final String userId;
  final double latitudeCreated;
  final double longitudeCreated;
  final String nameCityCreated;
  final List<String> images;

  const ProductScreen({
    super.key,
    required this.id,
    required this.marca,
    required this.modelo,
    required this.descripcion,
    required this.precio,
    required this.fecha,
    required this.categoria,
    required this.estado,
    required this.userId,
    required this.latitudeCreated,
    required this.longitudeCreated,
    required this.nameCityCreated,
    this.images = const [],
  });

  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  @override
  void initState() {
    super.initState();
    final categoryState = context.read<ProductCategoryBloc>().state;
    if (categoryState.productCategories == null || categoryState.productCategories!.isEmpty) {
      context.read<ProductCategoryBloc>().add(GetProductCategoryButtonPressed());
    }

    final stateState = context.read<ProductStateBloc>().state;
    if (stateState.productStates == null || stateState.productStates!.isEmpty) {
      context.read<ProductStateBloc>().add(GetProductStateButtonPressed());
    }
  }

  @override
  Widget build(BuildContext context) {
    final baseUrl = dotenv.env['BASE_API_URL'] ?? 'http://localhost:3000';
    final prefs = sl<SharedPreferences>();
    final id = prefs.getString('id');
    return Scaffold(
      appBar: AppBar(
        title: Text("${widget.marca} ${widget.modelo}"),
      ),
      body: BlocListener<ProductBloc, ProductState>(
        listener: (context, state) {
          if (state.purchaseSuccess == true) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(AppLocalizations.of(context)!.saleRealized)));
            context.push('/home');
          } else if (state.errorMessage != null) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(AppLocalizations.of(context)!.notEnoughBalance)));
          }
        },
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(18.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 16),
                CarouselSlider(
                  options: CarouselOptions(
                    height: 400.0,
                    enlargeCenterPage: true,
                    autoPlay: false,
                    enableInfiniteScroll: false,
                    viewportFraction: 0.9,
                  ),
                  items: widget.images.isNotEmpty ? widget.images.map((url) {
                    return Builder(
                      builder: (BuildContext context) {
                        return ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.network('$baseUrl$url', fit: BoxFit.cover, width: double.infinity),
                        );
                      },
                    );
                    }).toList() : [
                      Center(child: Text(AppLocalizations.of(context)!.noImagesAvailable)),
                    ],
                ),
                const SizedBox(height: 16),
                Text(AppLocalizations.of(context)!.productPrice(widget.precio), style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.green)),
                const SizedBox(height: 20),
                Text(widget.marca, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Text(widget.modelo, style: const TextStyle(fontSize: 18, color: Colors.grey)),
                const SizedBox(height: 25),
                if (widget.userId != id)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: TextButton(
                      onPressed: () {
                        context.read<ProductBloc>().add(BuyProductButtonPressed(productId: widget.id, userId: id ?? 'Sin id'));
                      },
                      style: TextButton.styleFrom(
                        backgroundColor: Colors.black,
                        minimumSize: const Size(double.infinity, 70),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.shopping_cart),
                          Text(AppLocalizations.of(context)!.buyProduct, style: const TextStyle(color: Color.fromARGB(255, 10, 185, 121), fontSize: 20, fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                  ),
                const SizedBox(height: 25),
                if (widget.userId != id)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: TextButton(
                      onPressed: () {
                        context.push(
                          '/chat',
                          extra: {
                            'productOwnerId': widget.userId,
                            'potBuyerId': id!,
                            'productId': widget.id,
                          },
                        );
                      },
                      style: TextButton.styleFrom(
                        backgroundColor:  const Color.fromARGB(255, 31, 194, 134), 
                        minimumSize: const Size(double.infinity, 70),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.chat_bubble),
                          Text(
                            AppLocalizations.of(context)!.chat,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                const SizedBox(height: 25),
                Text(widget.descripcion, style: const TextStyle(fontSize: 16)),
                const SizedBox(height: 16),
                BlocBuilder<ProductCategoryBloc, ProductCategoryState>(
                  builder: (context, state) {
                    if (state.errorMessage != null) {
                      return Text(AppLocalizations.of(context)!.error);
                    } else if (state.productCategories != null && state.productCategories!.isNotEmpty) {
                      final category = state.productCategories!.firstWhere(
                        (category) => category.idCategoryProduct == widget.categoria, orElse: () => ProductCategoryEntity(
                          idCategoryProduct: -1,
                          name: AppLocalizations.of(context)!.categoryNotFound,
                          description: '',
                        ),
                      );
                      return Text(AppLocalizations.of(context)!.showCategory(category.name), style: const TextStyle(fontSize: 16));
                    }
                    return Text(AppLocalizations.of(context)!.categoriesNotFound);
                  },
                ),
                BlocBuilder<ProductStateBloc, ProductStateState>(
                  builder: (context, state) {
                    if (state.isLoading) {
                      return Text(AppLocalizations.of(context)!.loadingProductState);
                    } else if (state.errorMessage != null) {
                      return Text(AppLocalizations.of(context)!.error);
                    } else if (state.productStates != null && state.productStates!.isNotEmpty) {
                      final productState = state.productStates!.firstWhere(
                        (productState) => productState.idStateProduct == widget.estado,
                        orElse: () => ProductStateEntity(
                          idStateProduct: -1,
                          name: AppLocalizations.of(context)!.stateNotFound,
                        ),
                      );
                      return Text(AppLocalizations.of(context)!.stateProduct(productState.name), style: const TextStyle(fontSize: 16));
                    }
                    return Text(AppLocalizations.of(context)!.statesNotFound);
                  },
                ),
                const SizedBox(height: 16),
                Text(AppLocalizations.of(context)!.dateCreated(widget.fecha), style: const TextStyle(fontSize: 14, color: Colors.grey)),
                const SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: SizedBox(
                    height: 250,
                    child: FlutterMap(
                      options: MapOptions(
                        initialCenter: LatLng(widget.latitudeCreated, widget.longitudeCreated),
                        initialZoom: 14.0,
                      ),
                      children: [
                        TileLayer(urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png", subdomains: ['a', 'b', 'c']),
                        MarkerLayer(
                          markers: [
                            Marker(
                              point: LatLng(widget.latitudeCreated, widget.longitudeCreated),
                              width: 40.0,
                              height: 40.0,
                              child: const Icon(
                                Icons.location_pin,
                                color: Color.fromARGB(255, 10, 185, 121),
                                size: 40.0,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
      drawer: const DrawerWidget(),
    );
  }
}