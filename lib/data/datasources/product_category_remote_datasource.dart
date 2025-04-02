import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' show jsonDecode;
import 'package:swapify/core/failure.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ProductCategoryDataSource {

  //obtiene las categorias de los producto
  Future<List<Map<String, dynamic>>> getProductCategory() async {
    try {
      final baseUrl = dotenv.env['BASE_API_URL'] ?? 'http://localhost:3000';
      final url = Uri.parse('$baseUrl/product_category');
      final response = await http.get(url, headers: {'Content-Type': 'application/json'});
      if (response.statusCode == 200) {
        return List<Map<String, dynamic>>.from(jsonDecode(response.body));
      } else {
        throw Exception('Error al obtener las categorias del producto');
      }
    } catch (e) {
      debugPrint("Error en getProductCategory: $e");
      throw ServerFailure();
    }
  }
}
