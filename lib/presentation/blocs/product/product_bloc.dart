import 'dart:math';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:swapify/core/usecase.dart';
import 'package:swapify/domain/entities/product.dart';
import 'package:swapify/domain/usecases/buy_product_usecase.dart';
import 'package:swapify/domain/usecases/delete_product_usecase.dart';
import 'package:swapify/domain/usecases/get_product_usecase.dart';
import 'package:swapify/domain/usecases/get_products_usecase.dart';
import 'package:swapify/domain/usecases/create_product_usecase.dart';
import 'package:swapify/domain/usecases/like_product_usecase.dart';
import 'package:swapify/domain/usecases/unlike_product_usecase.dart';
import 'package:swapify/domain/usecases/update_product_images_usecase.dart';
import 'package:swapify/domain/usecases/update_product_usecase.dart';
import 'package:swapify/domain/usecases/upload_product_images_usecase.dart';
import 'package:swapify/presentation/blocs/product/product_event.dart';
import 'package:swapify/presentation/blocs/product/product_state.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final GetProductsUseCase getProductsUseCase;
  final GetProductUseCase getProductUseCase;
  final CreateProductUseCase createProductUseCase;
  final UploadProductImagesUseCase uploadProductImagesUseCase;
  final DeleteProductUseCase deleteProductUseCase;
  final LikeProductUseCase likeProductUseCase;
  final UnlikeProductUseCase unlikeProductUseCase;
  final BuyProductUseCase buyProductUseCase;
  final UpdateProductUseCase updateProductUseCase;
  final UpdateProductImagesUseCase updateProductImagesUseCase;

  ProductBloc(
    this.getProductsUseCase, 
    this.getProductUseCase, 
    this.createProductUseCase, 
    this.deleteProductUseCase, 
    this.likeProductUseCase, 
    this.unlikeProductUseCase, 
    this.uploadProductImagesUseCase, 
    this.buyProductUseCase,
    this.updateProductUseCase,
    this.updateProductImagesUseCase): super(ProductState.initial()) {

    on<GetProductsButtonPressed>((event, emit) async {
      emit(ProductState.loading());
      try {
        final products = await getProductsUseCase(NoParams());
        emit(ProductState.success(products));
      } catch (e) {
        emit(ProductState.failure("Fallo al obtener los productos: $e"));
      }
    });

    on<GetProductButtonPressed>((event, emit) async {
      emit(ProductState.loading());
      try {
        final product = await getProductUseCase(GetProductParams(productId: event.productId));
        emit(ProductState.successSingle(product));
      } catch (e) {
        emit(ProductState.failure("Fallo al obtener el producto: $e"));
      }
    });

    on<BuyProductButtonPressed>((event, emit) async {
      emit(ProductState.loading());
      try {
        await buyProductUseCase.call(BuyProductParams(
          productId: event.productId,
          userId: event.userId,
        ));
        emit(state.copyWith(
          purchaseSuccess: true,
          errorMessage: null,
        ));
        add(GetProductsButtonPressed());
      } catch (e) {
        emit(state.copyWith(
          purchaseSuccess: false,
          errorMessage: "Error al comprar el producto: $e (saldo insuficiente)",
        ));
      }
    });

    on<DeleteProductButtonPressed>((event, emit) async {
      emit(ProductState.loading());
      try {
        await deleteProductUseCase(DeleteProductParams(id: event.id));
        add(GetProductsButtonPressed());
      } catch (e) {
        emit(ProductState.failure("Fallo al eliminar el producto: $e"));
      }
    });

    on<LikeProductButtonPressed>((event, emit) async {
      emit(ProductState.loading());
      try {
        await likeProductUseCase(LikeProductParams(userId: event.userId, productId: event.productId));
        add(GetProductsButtonPressed());
      } catch (e) {
        emit(ProductState.failure("Fallo al dar like al producto: $e"));
      }
    });

    on<UnlikeProductButtonPressed>((event, emit) async {
      emit(ProductState.loading());
      try {
        await unlikeProductUseCase(UnlikeProductParams(userId: event.userId, productId: event.productId));
        add(GetProductsButtonPressed());
      } catch (e) {
        emit(ProductState.failure("Fallo al quitar like al producto: $e"));
      }
    });

    on<FilterProductsButtonPressed>((event, emit) async {
      if (state.products == null) return;
      final searchTermLower = event.searchTerm?.toLowerCase();
      final filtered = state.products!.where((product) {
        final matchesSearch = searchTermLower == null || searchTermLower.isEmpty ||
            product.productBrand.toLowerCase().contains(searchTermLower) ||
            product.productModel.toLowerCase().contains(searchTermLower) ||
            product.description.toLowerCase().contains(searchTermLower);
        final matchesPrice = (event.minPrice == null || product.price >= event.minPrice!) &&
            (event.maxPrice == null || product.price <= event.maxPrice!);
        final matchesProximity = event.proximity == null || (() {
          const double earthRadius = 6371;
          final double dLat = (product.latitudeCreated - event.userLatitude) * (pi / 180);
          final double dLon = (product.longitudeCreated - event.userLongitude) * (pi / 180);
          final double a = sin(dLat / 2) * sin(dLat / 2) +
              cos(event.userLatitude * (pi / 180)) * cos(product.latitudeCreated * (pi / 180)) *
              sin(dLon / 2) * sin(dLon / 2);
          final double c = 2 * atan2(sqrt(a), sqrt(1 - a));
          return earthRadius * c;
        }()) <= event.proximity!;
        final matchesCategory = event.categoryId == null || product.idCategoryProduct == event.categoryId;
        return matchesSearch && matchesPrice && matchesProximity && matchesCategory;
      }).toList();
      emit(state.copyWith(
        filteredProducts: filtered,
        sortedProducts: null,
      ));
    });

    on<SortProductsButtonPressed>((event, emit) async {
      final targetProducts = state.filteredProducts ?? state.products ?? [];
      List<ProductEntity> sorted = List.from(targetProducts);
      sorted.sort((a, b) {
        if (event.criteria == "fecha") {
          return event.direction == "asc" ? a.createdAt.compareTo(b.createdAt) : b.createdAt.compareTo(a.createdAt);
        } else if (event.criteria == "precio") {
          return event.direction == "asc" ? a.price.compareTo(b.price) : b.price.compareTo(a.price);
        } else if (event.criteria == "distancia") {
          const double earthRadius = 6371;
          final double distanceA = (() {
            final double dLat = (a.latitudeCreated - event.userLatitude) * (pi / 180);
            final double dLon = (a.longitudeCreated - event.userLongitude) * (pi / 180);
            final double _a = sin(dLat / 2) * sin(dLat / 2) +
                cos(event.userLatitude * (pi / 180)) * cos(a.latitudeCreated * (pi / 180)) *
                sin(dLon / 2) * sin(dLon / 2);
            final double c = 2 * atan2(sqrt(_a), sqrt(1 - _a));
            return earthRadius * c;
          }());
          final double distanceB = (() {
            final double dLat = (b.latitudeCreated - event.userLatitude) * (pi / 180);
            final double dLon = (b.longitudeCreated - event.userLongitude) * (pi / 180);
            final double _a = sin(dLat / 2) * sin(dLat / 2) +
                cos(event.userLatitude * (pi / 180)) * cos(b.latitudeCreated * (pi / 180)) *
                sin(dLon / 2) * sin(dLon / 2);
            final double c = 2 * atan2(sqrt(_a), sqrt(1 - _a));
            return earthRadius * c;
          }());
          return event.direction == "asc" ? distanceA.compareTo(distanceB) : distanceB.compareTo(distanceA);
        }
        return 0;
      });
      emit(state.copyWith(sortedProducts: sorted));
    });

    on<CreateProductButtonPressed>((event, emit) async {
      emit(ProductState.loading());
      try {
        final productId = await createProductUseCase.call(CreateProductParams(
          productModel: event.productModel,
          productBrand: event.productBrand,
          price: event.price,
          description: event.description,
          latitudeCreated: event.latitudeCreated,
          longitudeCreated: event.longitudeCreated,
          nameCityCreated: event.nameCityCreated,
          userId: event.userId,
          idCategoryProduct: event.idCategoryProduct,
          idStateProduct: event.idStateProduct,
        ));
        if (event.images.isNotEmpty) {
          await uploadProductImagesUseCase.call(UploadProductImagesParams(
            productId: productId,
            images: event.images,
          ));
        }
        add(GetProductsButtonPressed());
      } catch (e) {
        emit(ProductState.failure("Error al crear el producto: $e"));
      }
    });

    on<UpdateProductButtonPressed>((event, emit) async {
      emit(ProductState.loading());
      try {
        await updateProductUseCase.call(UpdateProductParams(
          productModel: event.productModel,
          productBrand: event.productBrand,
          price: event.price,
          description: event.description,
          productId: event.productId,
          idCategoryProduct: event.idCategoryProduct,
          idStateProduct: event.idStateProduct,
        ));
        if (event.images.isNotEmpty) {
          await updateProductImagesUseCase.call(UpdateProductImagesParams(
            productId: event.productId,
            images: event.images,
          ));
        }
        add(GetProductsButtonPressed());
      } catch (e) {
        emit(ProductState.failure("Error al modificar el producto: $e"));
      }
    });
  }
}
