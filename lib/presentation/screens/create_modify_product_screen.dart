import 'package:flutter/foundation.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:image_picker/image_picker.dart';
import 'package:swapify/injection.dart';
import 'package:swapify/presentation/blocs/position/position_bloc.dart';
import 'package:swapify/presentation/blocs/position/position_event.dart';
import 'package:swapify/presentation/blocs/position/position_state.dart';
import 'package:swapify/presentation/blocs/product/product_bloc.dart';
import 'package:swapify/presentation/blocs/product/product_event.dart';
import 'package:swapify/presentation/blocs/product_sale_state/product_sale_state_bloc.dart';
import 'package:swapify/presentation/blocs/product_sale_state/product_sale_state_event.dart';
import 'package:swapify/presentation/blocs/product_sale_state/product_sale_state_state.dart';
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
  final int? estadoVenta;
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
    this.estadoVenta,
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
  late int? selectedSaleStateId;
  final baseUrl = dotenv.env['BASE_API_URL'] ?? 'http://localhost:3000';
  final List<File> _selectedImages = [];
  bool isFree = false;

  @override
  void initState() {
    super.initState();
    marcaController = TextEditingController(text: widget.marca ?? '');
    modeloController = TextEditingController(text: widget.modelo ?? '');
    descripcionController = TextEditingController(text: widget.descripcion ?? '');
    precioController = TextEditingController(text: widget.precio?.toStringAsFixed(2) ?? '0.00');
    selectedCategoryId = widget.categoria;
    selectedStateId = widget.estado;
    selectedSaleStateId = widget.estadoVenta ?? 0;
    _selectedImages.addAll(widget.images?.map((xFile) => File(xFile.path)) ?? []);
    final positionState = context.read<PositionBloc>().state;
    if (positionState.latitude == null || positionState.longitude == null) {
      context.read<PositionBloc>().add(GetPositionButtonPressed());
    }
    context.read<ProductCategoryBloc>().add(GetProductCategoryButtonPressed());
    context.read<ProductStateBloc>().add(GetProductStateButtonPressed());
    context.read<ProductSaleStateBloc>().add(GetProductSaleStateButtonPressed());
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
        title: Text(widget.productId == null ? AppLocalizations.of(context)!.createProduct : AppLocalizations.of(context)!.modifyProduct),
      ),
      body: MultiBlocListener(
        listeners: [
          BlocListener<ProductCategoryBloc, ProductCategoryState>(
            listener: (context, state) {
              if (state.errorMessage != null) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.errorMessage!)));
              }
            },
          ),
          BlocListener<ProductStateBloc, ProductStateState>(
            listener: (context, state) {
              if (state.errorMessage != null) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.errorMessage!)));
              }
            },
          ),
          BlocListener<ProductSaleStateBloc, ProductSaleStateState>(
            listener: (context, state) {
              if (state.errorMessage != null) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.errorMessage!)));
              }
            },
          ),
        ],
        child: BlocBuilder<ProductCategoryBloc, ProductCategoryState>(
          builder: (context, categoryState) {
            return BlocBuilder<ProductSaleStateBloc, ProductSaleStateState>(
              builder: (context, saleStateState) {
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
                      final saleStates = saleStateState.productSaleStates!;
                      final prefs = sl<SharedPreferences>();
                      final userProductId = prefs.getString('id');
                  return BlocBuilder<PositionBloc, PositionState>(
                    builder: (context, positionState) {
                      if (positionState.isLoading) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (positionState.latitude != null && positionState.longitude != null) {
                        return SingleChildScrollView(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const SizedBox(height: 40),
                            WidgetTextoFormulario(texto: AppLocalizations.of(context)!.brand, iconoHint: const Icon(Icons.local_offer), controller: marcaController),
                            const SizedBox(height: 12),
                            WidgetTextoFormulario(texto: AppLocalizations.of(context)!.model, iconoHint: const Icon(Icons.style), controller: modeloController),
                            const SizedBox(height: 12),
                            WidgetTextoFormulario(texto: AppLocalizations.of(context)!.description, iconoHint: const Icon(Icons.article), controller: descripcionController),
                            if (isFree != true)
                              const SizedBox(height: 12),
                            if (isFree != true)
                              WidgetTextoPrecio(texto: AppLocalizations.of(context)!.price, controller: precioController), 
                            const SizedBox(height: 16),
                            Padding(
                              padding: const EdgeInsets.only(left: 16), 
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start, 
                                children: [
                                  Checkbox(
                                    value: isFree,
                                    onChanged: (bool? newValue) {
                                      setState(() {
                                        isFree = newValue ?? false;
                                        if (isFree) {
                                          precioController.text = '0.00';
                                        }
                                      });
                                    },
                                  ),
                                  const SizedBox(width: 5), 
                                  Text(
                                    AppLocalizations.of(context)!.free,
                                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 16),
                            WidgetDropdownCategory(
                              items: categories,
                              selectedItemId: selectedCategoryId,
                              onChanged: (int? newValue) {
                                setState(() {
                                  selectedCategoryId = newValue;
                                });
                              },
                              hintText: AppLocalizations.of(context)!.productCategory,
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
                              hintText: AppLocalizations.of(context)!.state,
                              getId: (state) => state.idStateProduct,
                              displayText: (state) => state.name,
                            ),
                            const SizedBox(height: 12),
                            if (widget.productId != null)
                              WidgetDropdownCategory(
                                items: saleStates,
                                selectedItemId: selectedSaleStateId,
                                onChanged: (int? newValue) {
                                  setState(() {
                                    selectedSaleStateId = newValue;
                                  });
                                },
                                hintText: AppLocalizations.of(context)!.state,
                                getId: (saleState) => saleState.idSaleStateProduct,
                                displayText: (saleState) => saleState.name,
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
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16),
                              child: TextButton(
                                onPressed: () async {
                                  final marca = marcaController.text.trim();
                                  final modelo = modeloController.text.trim();
                                  final descripcion = descripcionController.text.trim();
                                  final precio = isFree ? '0.00' : precioController.text.trim();
                                  double? precioParsed = double.tryParse(precio);
                                  if (_selectedImages.isEmpty) {
                                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(AppLocalizations.of(context)!.errorFieldImages)));
                                    return;
                                  } else if (marca.isEmpty) {
                                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(AppLocalizations.of(context)!.errorFieldBrand)));
                                    return;
                                  } else if (modelo.isEmpty) {
                                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(AppLocalizations.of(context)!.errorFieldModel)));
                                    return;
                                  } else if (descripcion.isEmpty) {
                                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(AppLocalizations.of(context)!.errorFieldDescription)));
                                    return;
                                  } else if (descripcion.length < 2) {
                                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(AppLocalizations.of(context)!.errorFieldDescriptionShort)));
                                    return;
                                  } else if (precio.isEmpty) {
                                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(AppLocalizations.of(context)!.errorFieldPrice)));
                                    return;
                                  } else if (!isFree && (precioParsed == null || precioParsed <= 0)) {
                                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(AppLocalizations.of(context)!.errorFieldPriceNumber)));
                                    return;
                                  } else if (selectedCategoryId == null) {
                                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(AppLocalizations.of(context)!.errorFieldCategory)));
                                    return;
                                  }
                                  try {
                                    final positionState = context.read<PositionBloc>().state;
                                    if (positionState.latitude == null || positionState.longitude == null) {
                                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(AppLocalizations.of(context)!.errorUbication)));
                                      return;
                                    }
                                    double? latitudeCreated = positionState.latitude;
                                    double? longitudeCreated = positionState.longitude;
                                    String? nameCityCreated = positionState.city;
                                    if (widget.productId == null) {
                                      context.read<ProductBloc>().add(CreateProductButtonPressed(
                                        productModel: modelo,
                                        productBrand: marca,
                                        idStateProduct: selectedStateId ?? 0,
                                        idCategoryProduct: selectedCategoryId ?? 0,
                                        description: descripcion,
                                        price: precioParsed ?? 0.00,
                                        latitudeCreated: latitudeCreated ?? 0.00000000000,
                                        longitudeCreated: longitudeCreated ?? 0.00000000000,
                                        nameCityCreated: nameCityCreated ?? "Ciudad desconocida",
                                        userId: userProductId ?? "No hay id",
                                        images: _selectedImages.map((file) => XFile(file.path)).toList(),
                                      ));
                                    } else {
                                      List<XFile> imageFiles = [];
                                        for (var file in _selectedImages) {
                                          if (kIsWeb) {
                                            Uint8List bytes = await file.readAsBytes();
                                            imageFiles.add(XFile.fromData(bytes, mimeType: 'image/png')); 
                                          } else {
                                            imageFiles.add(XFile(file.path));
                                          }
                                        }
                                      context.read<ProductBloc>().add(UpdateProductButtonPressed(
                                        productId: widget.productId!,
                                        productModel: modelo,
                                        productBrand: marca,
                                        idStateProduct: selectedStateId ?? 0,
                                        idSaleStateProduct: selectedSaleStateId ?? 0,
                                        idCategoryProduct: selectedCategoryId ?? 0,
                                        description: descripcion,
                                        price: precioParsed ?? 0.00,
                                        images: imageFiles,
                                        userId: userProductId ?? "No hay id",
                                      ));
                                    }
                                    context.push('/home');
                                  } catch (e) {
                                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(AppLocalizations.of(context)!.errorObtainingUbication)));
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
                                  widget.productId == null ? AppLocalizations.of(context)!.createProduct : AppLocalizations.of(context)!.modifyProduct,
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 12),
                            if (widget.productId != null)
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 16),
                                child: TextButton(
                                  onPressed: () {
                                    context.read<ProductBloc>().add(DeleteProductButtonPressed(id: widget.productId!));
                                    context.push('/home');
                                  },
                                  style: TextButton.styleFrom(backgroundColor: Colors.black, minimumSize: const Size(double.infinity, 70), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                                  child: Text(AppLocalizations.of(context)!.deleteProduct, style: const TextStyle(color: Color.fromARGB(255, 10, 185, 121), fontSize: 20, fontWeight: FontWeight.bold)),
                                ),
                              ),
                            const SizedBox(height: 12),
                          ],
                        ),
                      );
                    } else {
                      return Center(
                        child: Text(AppLocalizations.of(context)!.errorUbication),
                        );
                      }
                    }
                  );
                } else {
                  return Center(child: Text(AppLocalizations.of(context)!.noDataAvailable));
                }
              },
            );
              }
            );
          },
        ),
      ),
    );
  }
}