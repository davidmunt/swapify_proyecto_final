import 'dart:math';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:swapify/domain/usecases/buy_product_usecase.dart';
import 'package:swapify/domain/usecases/delete_product_usecase.dart';
import 'package:swapify/domain/usecases/exchange_product_usecase.dart';
import 'package:swapify/domain/usecases/get_filtered_products_usecase.dart';
import 'package:swapify/domain/usecases/get_product_usecase.dart';
import 'package:swapify/domain/usecases/get_products_usecase.dart';
import 'package:swapify/domain/usecases/create_product_usecase.dart';
import 'package:swapify/domain/usecases/get_youre_envolvment_products_usecase.dart';
import 'package:swapify/domain/usecases/get_youre_liked_products_usecase.dart';
import 'package:swapify/domain/usecases/get_youre_products_usecase.dart';
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
  final GetYoureProductsUseCase getYoureProductsUseCase;
  final GetYoureLikedProductsUseCase getYoureLikedProductsUseCase;
  final GetYoureEnvolvmentProductsUseCase getYoureEnvolvmentProductsUseCase;
  final CreateProductUseCase createProductUseCase;
  final UploadProductImagesUseCase uploadProductImagesUseCase;
  final DeleteProductUseCase deleteProductUseCase;
  final LikeProductUseCase likeProductUseCase;
  final UnlikeProductUseCase unlikeProductUseCase;
  final BuyProductUseCase buyProductUseCase;
  final ExchangeProductUseCase exchangeProductUseCase;
  final UpdateProductUseCase updateProductUseCase;
  final UpdateProductImagesUseCase updateProductImagesUseCase;

  ProductBloc(
    this.getProductsUseCase, 
    this.getProductUseCase, 
    this.getFilteredProductsUseCase, 
    this.getYoureProductsUseCase, 
    this.getYoureLikedProductsUseCase, 
    this.getYoureEnvolvmentProductsUseCase, 
    this.createProductUseCase, 
    this.deleteProductUseCase, 
    this.likeProductUseCase, 
    this.unlikeProductUseCase, 
    this.uploadProductImagesUseCase, 
    this.buyProductUseCase,
    this.exchangeProductUseCase,
    this.updateProductUseCase,
    this.updateProductImagesUseCase): super(ProductState.initial()) {

    on<GetProductsButtonPressed>((event, emit) async {
      emit(ProductState.loading());
      try {
        add(FilterProductsButtonPressed(userId: event.userId));
      } catch (e) {
        emit(ProductState.failure("Fallo al obtener los productos: $e"));
      }
    });

    on<FilterProductsButtonPressed>((event, emit) async {
      emit(ProductState.loading());
      try {
        final searchTerm = event.searchTerm ?? state.currentSearchTerm;
        final isFree = (event.isFree ?? state.isFree) ?? false;
        final proximity = event.proximity ?? state.currentProximity;
        final categoryId = event.categoryId ?? state.currentCategoryId;
        final criteria = event.criteria?.isNotEmpty == true && event.criteria != "sinOrden" ? event.criteria : state.currentSortCriteria;
        final direction = event.direction ?? state.currentSortDirection;
        final userLatitude = event.userLatitude;
        final userLongitude = event.userLongitude;
        final minPrice = isFree ? 0.00 : (event.minPrice ?? state.currentMinPrice);
        final maxPrice = isFree ? 0.00 : (event.maxPrice ?? state.currentMaxPrice);
        final products = await getFilteredProductsUseCase.call(GetFilteredProductsParams(
          filters: {
            if (searchTerm != null) 'busqueda': searchTerm,
            if (minPrice != null) 'precioMin': minPrice.toString(),
            if (maxPrice != null) 'precioMax': maxPrice.toString(),
            if (proximity != null) 'proximidad': proximity.toString(),
            if (categoryId != null) 'categoriaProd': categoryId.toString(),
            'latitud_usuario': userLatitude.toString(),
            'longitud_usuario': userLongitude.toString(),
            'userId': event.userId,
          },
        ));
        if (criteria != null && criteria.isNotEmpty) {
          products.sort((a, b) {
            if (criteria == "fecha") {
              return direction == "asc" ? a.createdAt.compareTo(b.createdAt) : b.createdAt.compareTo(a.createdAt);
            } else if (criteria == "precio") {
              return direction == "asc" ? a.price.compareTo(b.price) : b.price.compareTo(a.price);
            } else if (criteria == "distancia") {
              const double earthRadius = 6371;
              double calcularDistancia(double lat1, double lon1, double lat2, double lon2) {
                double dLat = (lat2 - lat1) * (pi / 180);
                double dLon = (lon2 - lon1) * (pi / 180);
                double a = sin(dLat / 2) * sin(dLat / 2) + cos(lat1 * (pi / 180)) * cos(lat2 * (pi / 180)) * sin(dLon / 2) * sin(dLon / 2);
                double c = 2 * atan2(sqrt(a), sqrt(1 - a));
                return earthRadius * c;
              }
              double distanceA = calcularDistancia(a.latitudeCreated, a.longitudeCreated, userLatitude!, userLongitude!);
              double distanceB = calcularDistancia(b.latitudeCreated, b.longitudeCreated, userLatitude, userLongitude);
              return direction == "asc" ? distanceA.compareTo(distanceB) : distanceB.compareTo(distanceA);
            }
            return 0;
          });
        }
        emit(state.copyWith(
          isLoading: false,
          products: products,
          currentSearchTerm: searchTerm,
          currentMinPrice: minPrice,
          currentMaxPrice: maxPrice,
          isFree: isFree,
          currentProximity: proximity,
          currentCategoryId: categoryId,
          currentSortCriteria: criteria,
          currentSortDirection: direction,
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

    on<GetYoureProductsButtonPressed>((event, emit) async {
      try {
        final userProducts = await getYoureProductsUseCase.call(GetYoureProductsParams(userId: event.userId));
        emit(state.copyWith(
          youreProducts: userProducts, 
          isLoading: false,
        ));
      } catch (e) {
        emit(state.copyWith(
          isLoading: false,
          errorMessage: "Fallo al obtener tus productos: $e",
        ));
      }
    });

    on<GetYoureLikedProductsButtonPressed>((event, emit) async {
      try {
        final likedProducts = await getYoureLikedProductsUseCase.call(GetYoureLikedProductsParams(userId: event.userId));
        emit(state.copyWith(
          youreLikedProducts: likedProducts, 
          isLoading: false,
        ));
      } catch (e) {
        emit(state.copyWith(
          isLoading: false,
          errorMessage: "Fallo al obtener tus productos: $e",
        ));
      }
    });

    on<GetYoureEnvolvmentProductsButtonPressed>((event, emit) async {
      try {
        final envolvmentProducts = await getYoureEnvolvmentProductsUseCase.call(GetYoureEnvolvmentProductsParams(userId: event.userId));
        emit(state.copyWith(
          youreEnvolvmentProducts: envolvmentProducts, 
          isLoading: false,
        ));
      } catch (e) {
        emit(state.copyWith(
          isLoading: false,
          errorMessage: "Fallo al obtener tus productos: $e",
        ));
      }
    });

    on<BuyProductButtonPressed>((event, emit) async {
      emit(ProductState.loading());
      try {
        await buyProductUseCase.call(BuyProductParams(
          productId: event.productId,
          userId: event.userId,
          sellerId: event.sellerId,
        ));
        emit(state.copyWith(
          products: state.products,
          purchaseSuccess: true,
          errorMessage: null,
        ));
        add(GetProductsButtonPressed(userId: event.userId));
      } catch (e) {
        emit(state.copyWith(
          purchaseSuccess: false,
          errorMessage: "Error al comprar el producto: $e (saldo insuficiente)",
        ));
      }
    });

    on<ExchangeProductButtonPressed>((event, emit) async {
      emit(ProductState.loading());
      try {
        await exchangeProductUseCase.call(ExchangeProductParams(
          productId: event.productId,
          producExchangedtId: event.producExchangedtId,
          userId: event.userId,
          sellerId: event.sellerId,
        ));
        emit(state.copyWith(
          products: state.products,
          purchaseSuccess: true,
          errorMessage: null,
        ));
        add(GetProductsButtonPressed(userId: event.userId));
      } catch (e) {
        emit(state.copyWith(
          purchaseSuccess: false,
          errorMessage: "Error al intercambiar el producto: $e",
        ));
      }
    });

    on<DeleteProductButtonPressed>((event, emit) async {
      emit(ProductState.loading());
      try {
        await deleteProductUseCase(DeleteProductParams(id: event.id));
        add(GetProductsButtonPressed(userId: event.userId));
      } catch (e) {
        emit(ProductState.failure("Fallo al eliminar el producto: $e"));
      }
    });

    on<LikeProductButtonPressed>((event, emit) async {
      try {
        await likeProductUseCase(LikeProductParams(userId: event.userId, productId: event.productId));
        final likedProducts = await getYoureLikedProductsUseCase.call(GetYoureLikedProductsParams(userId: event.userId));
        final searchTerm = state.currentSearchTerm;
        final isFree = state.isFree ?? false;
        final proximity = state.currentProximity;
        final categoryId = state.currentCategoryId;
        final criteria = state.currentSortCriteria != null && state.currentSortCriteria!.isNotEmpty && state.currentSortCriteria != "sinOrden" ? state.currentSortCriteria : null;
        final direction = state.currentSortDirection;
        final userLatitude = event.userLatitude;
        final userLongitude = event.userLongitude;
        final minPrice = isFree ? 0.00 : state.currentMinPrice;
        final maxPrice = isFree ? 0.00 : state.currentMaxPrice;
        final products = await getFilteredProductsUseCase.call(GetFilteredProductsParams(
          filters: {
            if (searchTerm != null) 'busqueda': searchTerm,
            if (minPrice != null) 'precioMin': minPrice.toString(),
            if (maxPrice != null) 'precioMax': maxPrice.toString(),
            if (proximity != null) 'proximidad': proximity.toString(),
            if (categoryId != null) 'categoriaProd': categoryId.toString(),
            'latitud_usuario': userLatitude.toString(),
            'longitud_usuario': userLongitude.toString(),
            'userId': event.userId,
          },
        ));
        if (criteria != null && criteria.isNotEmpty) {
          products.sort((a, b) {
            if (criteria == "fecha") {
              return direction == "asc" ? a.createdAt.compareTo(b.createdAt) : b.createdAt.compareTo(a.createdAt);
            } else if (criteria == "precio") {
              return direction == "asc" ? a.price.compareTo(b.price) : b.price.compareTo(a.price);
            } else if (criteria == "distancia") {
              const double earthRadius = 6371;
              double calcularDistancia(double lat1, double lon1, double lat2, double lon2) {
                double dLat = (lat2 - lat1) * (pi / 180);
                double dLon = (lon2 - lon1) * (pi / 180);
                double a = sin(dLat / 2) * sin(dLat / 2) + cos(lat1 * (pi / 180)) * cos(lat2 * (pi / 180)) * sin(dLon / 2) * sin(dLon / 2);
                double c = 2 * atan2(sqrt(a), sqrt(1 - a));
                return earthRadius * c;
              }
              double distanceA = calcularDistancia(a.latitudeCreated, a.longitudeCreated, userLatitude!, userLongitude!);
              double distanceB = calcularDistancia(b.latitudeCreated, b.longitudeCreated, userLatitude, userLongitude);
              return direction == "asc" ? distanceA.compareTo(distanceB) : distanceB.compareTo(distanceA);
            }
            return 0;
          });
        }
        emit(state.copyWith(
          youreLikedProducts: likedProducts, 
          isLoading: false,
          products: products,
          currentSearchTerm: searchTerm,
          currentMinPrice: minPrice,
          currentMaxPrice: maxPrice,
          isFree: isFree,
          currentProximity: proximity,
          currentCategoryId: categoryId,
          currentSortCriteria: criteria,
          currentSortDirection: direction,
        ));
        // add(FilterProductsButtonPressed(
        //   searchTerm: state.currentSearchTerm,
        //   minPrice: state.currentMinPrice,
        //   maxPrice: state.currentMaxPrice,
        //   isFree: state.isFree,
        //   proximity: state.currentProximity,
        //   categoryId: state.currentCategoryId,
        //   criteria: state.currentSortCriteria,
        //   direction: state.currentSortDirection,
        //   userLatitude: event.userLatitude,
        //   userLongitude: event.userLongitude,
        //   userId: event.userId,
        // ));
        //add(GetYoureLikedProductsButtonPressed(userId: event.userId));
      } catch (e) {
        emit(state.copyWith(errorMessage: "Fallo al dar like al producto: $e"));
      }
    });

    on<UnlikeProductButtonPressed>((event, emit) async {
      try {
        await unlikeProductUseCase(UnlikeProductParams(userId: event.userId, productId: event.productId));
        final likedProducts = await getYoureLikedProductsUseCase.call(GetYoureLikedProductsParams(userId: event.userId));
        final searchTerm = state.currentSearchTerm;
        final isFree = state.isFree ?? false;
        final proximity = state.currentProximity;
        final categoryId = state.currentCategoryId;
        final criteria = state.currentSortCriteria != null && state.currentSortCriteria!.isNotEmpty && state.currentSortCriteria != "sinOrden" ? state.currentSortCriteria : null;
        final direction = state.currentSortDirection;
        final userLatitude = event.userLatitude;
        final userLongitude = event.userLongitude;
        final minPrice = isFree ? 0.00 : state.currentMinPrice;
        final maxPrice = isFree ? 0.00 : state.currentMaxPrice;
        final products = await getFilteredProductsUseCase.call(GetFilteredProductsParams(
          filters: {
            if (searchTerm != null) 'busqueda': searchTerm,
            if (minPrice != null) 'precioMin': minPrice.toString(),
            if (maxPrice != null) 'precioMax': maxPrice.toString(),
            if (proximity != null) 'proximidad': proximity.toString(),
            if (categoryId != null) 'categoriaProd': categoryId.toString(),
            'latitud_usuario': userLatitude.toString(),
            'longitud_usuario': userLongitude.toString(),
            'userId': event.userId,
          },
        ));
        if (criteria != null && criteria.isNotEmpty) {
          products.sort((a, b) {
            if (criteria == "fecha") {
              return direction == "asc" ? a.createdAt.compareTo(b.createdAt) : b.createdAt.compareTo(a.createdAt);
            } else if (criteria == "precio") {
              return direction == "asc" ? a.price.compareTo(b.price) : b.price.compareTo(a.price);
            } else if (criteria == "distancia") {
              const double earthRadius = 6371;
              double calcularDistancia(double lat1, double lon1, double lat2, double lon2) {
                double dLat = (lat2 - lat1) * (pi / 180);
                double dLon = (lon2 - lon1) * (pi / 180);
                double a = sin(dLat / 2) * sin(dLat / 2) + cos(lat1 * (pi / 180)) * cos(lat2 * (pi / 180)) * sin(dLon / 2) * sin(dLon / 2);
                double c = 2 * atan2(sqrt(a), sqrt(1 - a));
                return earthRadius * c;
              }
              double distanceA = calcularDistancia(a.latitudeCreated, a.longitudeCreated, userLatitude!, userLongitude!);
              double distanceB = calcularDistancia(b.latitudeCreated, b.longitudeCreated, userLatitude, userLongitude);
              return direction == "asc" ? distanceA.compareTo(distanceB) : distanceB.compareTo(distanceA);
            }
            return 0;
          });
        }
        emit(state.copyWith(
          youreLikedProducts: likedProducts, 
          isLoading: false,
          products: products,
          currentSearchTerm: searchTerm,
          currentMinPrice: minPrice,
          currentMaxPrice: maxPrice,
          isFree: isFree,
          currentProximity: proximity,
          currentCategoryId: categoryId,
          currentSortCriteria: criteria,
          currentSortDirection: direction,
        ));
        // add(FilterProductsButtonPressed(
        //   searchTerm: state.currentSearchTerm,
        //   minPrice: state.currentMinPrice,
        //   maxPrice: state.currentMaxPrice,
        //   isFree: state.isFree,
        //   proximity: state.currentProximity,
        //   categoryId: state.currentCategoryId,
        //   criteria: state.currentSortCriteria,
        //   direction: state.currentSortDirection,
        //   userLatitude: event.userLatitude,
        //   userLongitude: event.userLongitude,
        //   userId: event.userId,
        // ));
        // add(GetYoureLikedProductsButtonPressed(userId: event.userId));
      } catch (e) {
        emit(state.copyWith(errorMessage: "Fallo al quitar like al producto: $e"));
      }
    });

    on<ResetFiltersButtonPressed>((event, emit) async {
      emit(state.copyWith(
        currentSearchTerm: null,
        currentMinPrice: null,
        currentMaxPrice: null,
        isFree: null,
        currentProximity: null,
        currentCategoryId: null,
        currentSortCriteria: null,
        currentSortDirection: null,
      ));
      add(GetProductsButtonPressed(userId: event.userId));
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
        add(GetYoureProductsButtonPressed(userId: event.userId));
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
        add(GetYoureProductsButtonPressed(userId: event.userId));
      } catch (e) {
        emit(ProductState.failure("Error al modificar el producto: $e"));
      }
    });
  }
}
