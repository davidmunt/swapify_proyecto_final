import 'dart:math';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:swapify/domain/entities/product.dart';
import 'package:swapify/domain/usecases/buy_product_usecase.dart';
import 'package:swapify/domain/usecases/delete_product_usecase.dart';
import 'package:swapify/domain/usecases/get_filtered_products_usecase.dart';
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
  final GetFilteredProductsUseCase getFilteredProductsUseCase;
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
    this.getFilteredProductsUseCase, 
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
        final products = await getFilteredProductsUseCase.call(GetFilteredProductsParams());
        emit(ProductState.success(products));
      } catch (e) {
        emit(ProductState.failure("Fallo al obtener los productos: $e"));
      }
    });

    on<FilterProductsButtonPressed>((event, emit) async {
      emit(ProductState.loading());
      try {
        final products = await getFilteredProductsUseCase.call(GetFilteredProductsParams(
          filters: {
            if (event.searchTerm != null) 'busqueda': event.searchTerm,
            if (event.minPrice != null) 'precioMin': event.minPrice.toString(),
            if (event.maxPrice != null) 'precioMax': event.maxPrice.toString(),
            if (event.proximity != null) 'proximidad': event.proximity.toString(),
            if (event.categoryId != null) 'categoriaProd': event.categoryId.toString(),
            'latitud_usuario': event.userLatitude.toString(),
            'longitud_usuario': event.userLongitude.toString(),
          },
        ));
        emit(state.copyWith(
          isLoading: false,
          products: products,
          currentSearchTerm: event.searchTerm,
          currentMinPrice: event.minPrice,
          currentMaxPrice: event.maxPrice,
          currentProximity: event.proximity,
          currentCategoryId: event.categoryId,
        ));
      } catch (e) {
        emit(ProductState.failure("Fallo al filtrar los productos: $e"));
      }
    });

    on<GetProductButtonPressed>((event, emit) async {
      emit(state.copyWith(isLoading: true));
      try {
        final product = await getProductUseCase(GetProductParams(productId: event.productId));
        emit(state.copyWith(
          product: product,
          products: state.products, 
          isLoading: false,
        ));
      } catch (e) {
        emit(state.copyWith(
          isLoading: false,
          errorMessage: "Fallo al obtener el producto: $e",
        ));
      }
    });

    // on<GetProductButtonPressed>((event, emit) async {
    //   emit(ProductState.loading());
    //   try {
    //     final product = await getProductUseCase(GetProductParams(productId: event.productId));
    //     emit(ProductState.successSingle(product));
    //   } catch (e) {
    //     emit(ProductState.failure("Fallo al obtener el producto: $e"));
    //   }
    // });

    on<BuyProductButtonPressed>((event, emit) async {
      emit(ProductState.loading());
      try {
        await buyProductUseCase.call(BuyProductParams(
          productId: event.productId,
          userId: event.userId,
          sellerId: event.sellerId,
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

    on<SortProductsButtonPressed>((event, emit) async {
      final currentProducts = state.products ?? [];
      List<ProductEntity> sortedProducts = List.from(currentProducts);
      sortedProducts.sort((a, b) {
        if (event.criteria == "fecha") {
          return event.direction == "asc" ? a.createdAt.compareTo(b.createdAt) : b.createdAt.compareTo(a.createdAt);
        } else if (event.criteria == "precio") {
          return event.direction == "asc" ? a.price.compareTo(b.price) : b.price.compareTo(a.price);
        } else if (event.criteria == "distancia") {
          const double earthRadius = 6371; 
          double distanceA = (() {
            double dLat = (a.latitudeCreated - event.userLatitude) * (pi / 180);
            double dLon = (a.longitudeCreated - event.userLongitude) * (pi / 180);
            double _a = sin(dLat / 2) * sin(dLat / 2) +
                cos(event.userLatitude * (pi / 180)) * cos(a.latitudeCreated * (pi / 180)) *
                sin(dLon / 2) * sin(dLon / 2);
            double c = 2 * atan2(sqrt(_a), sqrt(1 - _a));
            return earthRadius * c;
          })();
          double distanceB = (() {
            double dLat = (b.latitudeCreated - event.userLatitude) * (pi / 180);
            double dLon = (b.longitudeCreated - event.userLongitude) * (pi / 180);
            double _a = sin(dLat / 2) * sin(dLat / 2) +
                cos(event.userLatitude * (pi / 180)) * cos(b.latitudeCreated * (pi / 180)) *
                sin(dLon / 2) * sin(dLon / 2);
            double c = 2 * atan2(sqrt(_a), sqrt(1 - _a));
            return earthRadius * c;
          })();
          return event.direction == "asc" ? distanceA.compareTo(distanceB) : distanceB.compareTo(distanceA);
        }
        return 0;
      });
      emit(state.copyWith(
        products: sortedProducts,
        currentSortCriteria: event.criteria,
        currentSortDirection: event.direction,
      ));
    });

    on<ResetFiltersButtonPressed>((event, emit) async {
      emit(state.copyWith(
        currentSearchTerm: null,
        currentMinPrice: null,
        currentMaxPrice: null,
        currentProximity: null,
        currentCategoryId: null,
        currentSortCriteria: null,
        currentSortDirection: null,
      ));
      add(GetProductsButtonPressed());
    });

    on<ResetSortButtonPressed>((event, emit) async {
      emit(state.copyWith(
        currentSortCriteria: null,
        currentSortDirection: null,
        currentSearchTerm: state.currentSearchTerm,
        currentMinPrice: state.currentMinPrice,
        currentMaxPrice: state.currentMaxPrice,
        currentCategoryId: state.currentCategoryId,
        currentProximity: state.currentProximity,
      ));
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
          idSaleStateProduct: event.idSaleStateProduct,
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
