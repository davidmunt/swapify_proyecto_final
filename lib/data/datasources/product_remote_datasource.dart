import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' show jsonDecode, jsonEncode;
import 'package:swapify/core/failure.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:swapify/data/models/product_model.dart';
import 'dart:typed_data';
import 'package:http_parser/http_parser.dart';

class ProductDataSource {

  ProductDataSource();

  Future<List<ProductModel>> getProducts() async {
    final baseUrl = dotenv.env['BASE_API_URL'] ?? 'http://localhost:3000';
    final url = Uri.parse('$baseUrl/product');
    final response = await http.get(url, headers: {'Content-Type': 'application/json'});
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body) as List<dynamic>;
      return data.map((product) => ProductModel.fromMap(product as Map<String, dynamic>)).toList();
    } else {
      throw Exception('Error al obtener productos');
    }
  }

  Future<List<ProductModel>> getFilteredProducts({Map<String, dynamic>? filters}) async {
    final baseUrl = dotenv.env['BASE_API_URL'] ?? 'http://localhost:3000';
    final url = Uri.parse('$baseUrl/product/filters');
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(filters ?? {}),
      );
      if (response.statusCode == 201) {
        final List<dynamic> data = jsonDecode(response.body) as List<dynamic>;
        return data.map((product) => ProductModel.fromMap(product as Map<String, dynamic>)).toList();
      } else {
        throw Exception('Error al obtener productos filtrados');
      }
    } catch (e) {
      debugPrint("Error en getFilteredProducts: $e");
      throw ServerFailure();
    }
  }

  Future<ProductModel> getProduct(int productId) async {
    final baseUrl = dotenv.env['BASE_API_URL'] ?? 'http://localhost:3000';
    final url = Uri.parse('$baseUrl/product/$productId');
    final response = await http.get(url, headers: {'Content-Type': 'application/json'});
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body) as Map<String, dynamic>;
      return ProductModel.fromMap(data);
    } else {
      throw Exception('Error al obtener el producto');
    }
  }

  Future<List<ProductModel>> getYoureLikedProducts(String userId) async {
    final baseUrl = dotenv.env['BASE_API_URL'] ?? 'http://localhost:3000';
    final url = Uri.parse('$baseUrl/product/likesProduct/$userId');
    final response = await http.get(url, headers: {'Content-Type': 'application/json'});
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body) as List<dynamic>;
      return data.map((product) => ProductModel.fromMap(product as Map<String, dynamic>)).toList();
    } else {
      throw Exception('Error al obtener productos');
    }
  }

  Future<List<ProductModel>> getYoureEnvolvmentProducts(String userId) async {
    final baseUrl = dotenv.env['BASE_API_URL'] ?? 'http://localhost:3000';
    final url = Uri.parse('$baseUrl/product/envolvement/$userId');
    final response = await http.get(url, headers: {'Content-Type': 'application/json'});
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body) as List<dynamic>;
      return data.map((product) => ProductModel.fromMap(product as Map<String, dynamic>)).toList();
    } else {
      throw Exception('Error al obtener productos');
    }
  }

  Future<List<ProductModel>> getYoureProducts(String userId) async {
    final baseUrl = dotenv.env['BASE_API_URL'] ?? 'http://localhost:3000';
    final url = Uri.parse('$baseUrl/product/user/$userId');
    final response = await http.get(url, headers: {'Content-Type': 'application/json'});
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body) as List<dynamic>;
      return data.map((product) => ProductModel.fromMap(product as Map<String, dynamic>)).toList();
    } else {
      throw Exception('Error al obtener productos');
    }
  }

  Future<void> deleteProduct(int id) async {
    try {
      final baseUrl = dotenv.env['BASE_API_URL'] ?? 'http://localhost:3000';
      final url = Uri.parse('$baseUrl/product/$id');
      final response = await http.delete(url, headers: {'Content-Type': 'application/json'});
      if (response.statusCode != 200) {
        throw Exception('Error al eliminar el producto');
      }
    } catch (e) {
      debugPrint("Error en deleteProduct: $e");
      throw Exception("Error al eliminar el producto");
    }
  }

  Future<void> buyProduct({
    required int productId,
    required String userId,
    required String sellerId,
  }) async {
    try {
      final baseUrl = dotenv.env['BASE_API_URL'] ?? 'http://localhost:3000';
      final url = Uri.parse('$baseUrl/product/buy');
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'productId': productId,
          'buyerId': userId,
          'sellerId': sellerId
        }),
      );
      if (response.statusCode != 201) {
        throw Exception('Error al comprar el producto');
      }
    } catch (e) {
      debugPrint("Error en buyProduct: $e");
      throw ServerFailure();
    }
  }

  Future<void> likeProduct({required int productId, required String userId}) async {
    final baseUrl = dotenv.env['BASE_API_URL'] ?? 'http://localhost:3000';
    final url = Uri.parse('$baseUrl/product_like');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'productId': productId, 'userId': userId}),
    );
    if (response.statusCode != 201) {
      throw Exception('Error al dar like al producto');
    }
  }

  Future<void> unlikeProduct({required int productId, required String userId}) async {
    final baseUrl = dotenv.env['BASE_API_URL'] ?? 'http://localhost:3000';
    final url = Uri.parse('$baseUrl/product_like');
    final response = await http.delete(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'productId': productId, 'userId': userId}),
    );
    if (response.statusCode != 204) {
      throw Exception('Error al quitar like al producto');
    }
  }

  Future<void> updateProduct({
    required String productModel,
    required String productBrand,
    required double price,
    required String description,
    required int idCategoryProduct,
    required int idStateProduct,
    required int idSaleStateProduct,
    required int productId,
  }) async {
    try {
      final baseUrl = dotenv.env['BASE_API_URL'] ?? 'http://localhost:3000';
      final url = Uri.parse('$baseUrl/product/$productId');
      final response = await http.put(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'product_model': productModel,
          'product_brand': productBrand,
          'price': price,
          'description': description,
          'id_category_product': idCategoryProduct,
          'id_state_product': idStateProduct,
          'id_sale_state_product': idSaleStateProduct,
        }),
      );
      if (response.statusCode != 200) {
        throw Exception('Error al modificar los datos del producto');
      } 
    } catch (e) {
      debugPrint("Error en updateProduct: $e");
      throw ServerFailure();
    }
  }

  Future<void> updateProductImages({
    required int productId,
    required List<XFile> images,
  }) async {
    try {
      final baseUrl = dotenv.env['BASE_API_URL'] ?? 'http://localhost:3000';
      final url = Uri.parse('$baseUrl/upload/product');
      final request = http.MultipartRequest('PUT', url);
      for (final image in images) {
        if (kIsWeb) {
          Uint8List imageBytes = await image.readAsBytes();
          request.files.add(http.MultipartFile.fromBytes(
            'file',
            imageBytes,
            filename: 'updated_product_image.png',
            contentType: MediaType('image', 'png'),
          ));
        } else {
          final fullPath = image.path.startsWith('/upload') ? '$baseUrl${image.path}' : image.path;
          request.files.add(await http.MultipartFile.fromPath('file', fullPath));
        }
      }
      request.fields['product'] = productId.toString();
      final response = await request.send();
      if (response.statusCode != 200) {
        throw Exception('Error al actualizar las imagenes del producto');
      }
    } catch (e) {
      debugPrint("Error en updateProductImages: $e");
      throw ServerFailure();
    }
  }

  Future<int> createProduct({
    required String productModel,
    required String productBrand,
    required double price,
    required String description,
    required double latitudeCreated,
    required double longitudeCreated,
    required String nameCityCreated,
    required String userId,
    required int idCategoryProduct,
    required int idStateProduct,
  }) async {
    try {
      final baseUrl = dotenv.env['BASE_API_URL'] ?? 'http://localhost:3000';
      final url = Uri.parse('$baseUrl/product');
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'product_model': productModel,
          'product_brand': productBrand,
          'price': price,
          'description': description,
          'latitude_created': latitudeCreated,
          'longitude_created': longitudeCreated,
          'name_city_created': nameCityCreated,
          'user_id': userId,
          'id_category_product': idCategoryProduct,
          'id_state_product': idStateProduct,
          'id_sale_state_product': 1,
        }),
      );
      if (response.statusCode == 201) {
        final responseData = jsonDecode(response.body);
        return responseData['id_product'];
      } else {
        throw Exception('Error al crear un producto');
      }
    } catch (e) {
      debugPrint("Error en createProduct: $e");
      throw ServerFailure();
    }
  }

  Future<void> uploadProductImages({
    required int productId,
    required List<XFile> images,
  }) async {
    try {
      final baseUrl = dotenv.env['BASE_API_URL'] ?? 'http://localhost:3000';
      final url = Uri.parse('$baseUrl/upload/product');
      final request = http.MultipartRequest('POST', url);
      for (final image in images) {
        if (kIsWeb) {
          Uint8List imageBytes = await image.readAsBytes();
          request.files.add(http.MultipartFile.fromBytes(
            'file',
            imageBytes,
            filename: 'product_image.png', 
            contentType: MediaType('image', 'png'), 
          ));
        } else {
          request.files.add(await http.MultipartFile.fromPath('file', image.path));
        }
      }
      request.fields['product'] = productId.toString();
      final response = await request.send();
      if (response.statusCode != 201) {
        throw Exception('Error al subir imágenes del producto');
      }
    } catch (e) {
      debugPrint("Error en uploadProductImages: $e");
      throw ServerFailure();
    }
  }


  // Future<void> uploadProductImages({
  //   required int productId,
  //   required List<XFile> images,
  // }) async {
  //   try {
  //     final baseUrl = dotenv.env['BASE_API_URL'] ?? 'http://localhost:3000';
  //     final url = Uri.parse('$baseUrl/upload/product');
  //     final request = http.MultipartRequest('POST', url);
  //     for (final image in images) {
  //       request.files.add(await http.MultipartFile.fromPath('file', image.path));
  //     }
  //     request.fields['product'] = productId.toString();
  //     final response = await request.send();
  //     if (response.statusCode != 200 && response.statusCode != 201) {
  //       throw Exception('Error al subir imagenes del producto');
  //     }
  //   } catch (e) {
  //     debugPrint("Error en uploadProductImages: $e");
  //     throw ServerFailure();
  //   }
  // }
}