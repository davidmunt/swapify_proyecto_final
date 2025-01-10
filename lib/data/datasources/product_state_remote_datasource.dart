import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' show jsonDecode;
import 'package:swapify/core/failure.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ProductStateDataSource {

  Future<List<Map<String, dynamic>>> getProductState() async {
    try {
      final baseUrl = dotenv.env['BASE_API_URL'] ?? 'http://localhost:3000';
      final url = Uri.parse('$baseUrl/product_state');
      final response = await http.get(url, headers: {'Content-Type': 'application/json'});
      if (response.statusCode == 200) {
        return List<Map<String, dynamic>>.from(jsonDecode(response.body));
      } else {
        throw Exception('Error al obtener los estados del producto');
      }
    } catch (e) {
      debugPrint("Error en getProductState: $e");
      throw ServerFailure();
    }
  }
}
