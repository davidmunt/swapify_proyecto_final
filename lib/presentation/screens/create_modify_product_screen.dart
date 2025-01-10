import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:image_picker/image_picker.dart';
import 'package:swapify/injection.dart';
import 'package:swapify/presentation/blocs/product/product_bloc.dart';
import 'package:swapify/presentation/blocs/product/product_event.dart';
import 'package:swapify/presentation/widgets/widget_images_selector.dart';
import 'dart:io';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:swapify/presentation/blocs/product_category/product_category_bloc.dart';
import 'package:swapify/presentation/blocs/product_category/product_category_event.dart';
import 'package:swapify/presentation/blocs/product_category/product_category_state.dart';
import 'package:swapify/presentation/blocs/product_state/product_state_bloc.dart';
import 'package:swapify/presentation/blocs/product_state/product_state_event.dart';
import 'package:swapify/presentation/blocs/product_state/product_state_state.dart';
import 'package:swapify/presentation/widgets/widget_dropdown_category.dart';
import 'package:swapify/presentation/widgets/widget_text_form.dart';
import 'package:swapify/presentation/widgets/widget_text_price_form.dart';

class CreateModifyProductScreen extends StatefulWidget {
  final int? productId;
  final String? marca;
  final String? modelo;
  final String? descripcion;
  final double? precio;
  final int? categoria;
  final int? estado;
  final List<XFile>? images;

  const CreateModifyProductScreen({
    super.key,
    this.productId,
    this.marca,
    this.modelo,
    this.descripcion,
    this.precio,
    this.categoria,
    this.estado,
    this.images,
  });

  @override
  State<CreateModifyProductScreen> createState() => _CreateModifyProductScreenState();
}

class _CreateModifyProductScreenState extends State<CreateModifyProductScreen> {
  late final TextEditingController marcaController;
  late final TextEditingController modeloController;
  late final TextEditingController descripcionController;
  late final TextEditingController precioController;
  late int? selectedCategoryId;
  late int? selectedStateId;
  final baseUrl = dotenv.env['BASE_API_URL'] ?? 'http://localhost:3000';
  final List<File> _selectedImages = [];

  @override
  void initState() {
    super.initState();
    marcaController = TextEditingController(text: widget.marca ?? '');
    modeloController = TextEditingController(text: widget.modelo ?? '');
    descripcionController = TextEditingController(text: widget.descripcion ?? '');
    precioController = TextEditingController(text: widget.precio?.toStringAsFixed(2) ?? '0.00');
    selectedCategoryId = widget.categoria;
    selectedStateId = widget.estado;
    _selectedImages.addAll(widget.images?.map((xFile) => File(xFile.path)) ?? []);
    context.read<ProductCategoryBloc>().add(GetProductCategoryButtonPressed());
    context.read<ProductStateBloc>().add(GetProductStateButtonPressed());
  }

  @override
  void dispose() {
    marcaController.dispose();
    modeloController.dispose();
    descripcionController.dispose();
    precioController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.productId == null ? "Crear producto" : "Modificar producto"),
      ),
      body: MultiBlocListener(
        listeners: [
          BlocListener<ProductCategoryBloc, ProductCategoryState>(
            listener: (context, state) {
              if (state.errorMessage != null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(state.errorMessage!)),
                );
              }
            },
          ),
          BlocListener<ProductStateBloc, ProductStateState>(
            listener: (context, state) {
              if (state.errorMessage != null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(state.errorMessage!)),
                );
              }
            },
          ),
        ],
        child: BlocBuilder<ProductCategoryBloc, ProductCategoryState>(
          builder: (context, categoryState) {
            return BlocBuilder<ProductStateBloc, ProductStateState>(
              builder: (context, stateState) {
                if (categoryState.isLoading || stateState.isLoading) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (categoryState.productCategories != null &&
                    stateState.productStates != null) {
                  final categories = categoryState.productCategories!;
                  final states = stateState.productStates!;
                  final prefs = sl<SharedPreferences>();
                  final userProductId = prefs.getString('id');
                  return SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(height: 40),
                        WidgetTextoFormulario(texto: "Marca", iconoHint: const Icon(Icons.local_offer), controller: marcaController),
                        const SizedBox(height: 12),
                        WidgetTextoFormulario(texto: "Modelo", iconoHint: const Icon(Icons.style), controller: modeloController),
                        const SizedBox(height: 12),
                        WidgetTextoFormulario(texto: "Descripcion", iconoHint: const Icon(Icons.article), controller: descripcionController),
                        const SizedBox(height: 12),
                        WidgetTextoPrecio(texto: "Precio en €", controller: precioController), 
                        const SizedBox(height: 12),
                        WidgetDropdownCategory(
                          items: categories,
                          selectedItemId: selectedCategoryId,
                          onChanged: (int? newValue) {
                            setState(() {
                              selectedCategoryId = newValue;
                            });
                          },
                          hintText: "Categoria del producto",
                          getId: (category) => category.idCategoryProduct,
                          displayText: (category) => category.name,
                        ),
                        const SizedBox(height: 12),
                        WidgetDropdownCategory(
                          items: states,
                          selectedItemId: selectedStateId,
                          onChanged: (int? newValue) {
                            setState(() {
                              selectedStateId = newValue;
                            });
                          },
                          hintText: "Estado del producto",
                          getId: (state) => state.idStateProduct,
                          displayText: (state) => state.name,
                        ),
                        const SizedBox(height: 12),
                        WidgetImagesSelector(
                          selectedImages: List<File>.from(_selectedImages),
                          baseUrl: baseUrl,
                          onImagesUpdated: (updatedImages) {
                            setState(() {
                              _selectedImages
                                ..clear()
                                ..addAll(updatedImages);
                            });
                          },
                        ),
                        const SizedBox(height: 12),
                        if (widget.productId != null)
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: TextButton(
                              onPressed: () {
                                context.read<ProductBloc>().add(DeleteProductButtonPressed(id: widget.productId!));
                                context.go('/home');
                              },
                              style: TextButton.styleFrom(backgroundColor: Colors.black, minimumSize: const Size(double.infinity, 70), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                              child: const Text("Elimina el producto", style: TextStyle(color: Color.fromARGB(255, 10, 185, 121), fontSize: 20, fontWeight: FontWeight.bold)),
                            ),
                          ),
                        const SizedBox(height: 12),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: TextButton(
                            onPressed: () async {
                              final marca = marcaController.text.trim();
                              final modelo = modeloController.text.trim();
                              final descripcion = descripcionController.text.trim();
                              final precio = precioController.text.trim();
                              double? precioParsed = double.tryParse(precio);
                              if (_selectedImages.isEmpty) {
                                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Debes seleccionar o capturar al menos una imagen.")));
                                return;
                              } else if (marca.isEmpty) {
                                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Tienes que escribir algo en el campo de la marca')));
                                return;
                              } else if (marca.length < 2) {
                                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('La marca no puede ser tan corta')));
                                return;
                              } else if (modelo.isEmpty) {
                                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Tienes que escribir algo el campo del modelo')));
                                return;
                              } else if (modelo.length < 2) {
                                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('El modelo no puede ser tan corto')));
                                return;
                              } else if (descripcion.isEmpty) {
                                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Tienes que escribir algo en el campo de descripcion')));
                                return;
                              } else if (descripcion.length < 4) {
                                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('La descripcion es demasiado corta')));
                                return;
                              } else if (precio.isEmpty) {
                                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Tienes que escribir un precio")));
                                return;
                              } else if (precioParsed == null) {
                                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("En el campo de precio solo puedes escribir numeros")));
                                return;
                              } else if (selectedCategoryId == null) {
                                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Tienes que seleccionar la categoria del producto")));
                                return;
                              }
                              try {
                                bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
                                if (!serviceEnabled) {
                                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Por favor habilita los servicios de ubicación.")));
                                  return;
                                }
                                LocationPermission permission = await Geolocator.checkPermission();
                                if (permission == LocationPermission.denied) {
                                  permission = await Geolocator.requestPermission();
                                  if (permission == LocationPermission.denied) {
                                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Permiso de ubicación denegado.")));
                                    return;
                                  }
                                }
                                Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
                                double latitudeCreated = position.latitude;
                                double longitudeCreated = position.longitude;
                                List<Placemark> placemarks = await placemarkFromCoordinates(latitudeCreated, longitudeCreated);
                                String nameCityCreated = placemarks.first.locality ?? "Ciudad desconocida";
                                if (widget.productId == null) {
                                  context.read<ProductBloc>().add(CreateProductButtonPressed(
                                    productModel: modelo,
                                    productBrand: marca,
                                    idStateProduct: selectedStateId ?? 0,
                                    idCategoryProduct: selectedCategoryId ?? 0,
                                    description: descripcion,
                                    price: precioParsed,
                                    latitudeCreated: latitudeCreated,
                                    longitudeCreated: longitudeCreated,
                                    nameCityCreated: nameCityCreated,
                                    userId: userProductId ?? "No hay id",
                                    images: _selectedImages.map((file) => XFile(file.path)).toList(),
                                  ));
                                } else {
                                  context.read<ProductBloc>().add(UpdateProductButtonPressed(
                                    productId: widget.productId!,
                                    productModel: modelo,
                                    productBrand: marca,
                                    idStateProduct: selectedStateId ?? 0,
                                    idCategoryProduct: selectedCategoryId ?? 0,
                                    description: descripcion,
                                    price: precioParsed,
                                    images: _selectedImages.map((file) => XFile(file.path)).toList(),
                                  ));
                                }
                                context.go('/home');
                              } catch (e) {
                                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error al obtener la ubicacion: $e")));
                              }
                            },
                            style: TextButton.styleFrom(
                              backgroundColor: const Color.fromARGB(255, 10, 185, 121),
                              minimumSize: const Size(double.infinity, 70),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: Text(
                              widget.productId == null ? "Crear producto" : "Modificar producto",
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                      ],
                    ),
                  );
                } else {
                  return const Center(child: Text("No hay datos disponibles"));
                }
              },
            );
          },
        ),
      ),
    );
  }
}