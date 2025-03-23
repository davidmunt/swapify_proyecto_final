import 'package:http/http.dart' as http;
import 'dart:convert' show jsonEncode;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ProductViewDataSource {

  Future<void> saveProductView({required int productId, required String userId}) async {
    final baseUrl = dotenv.env['BASE_API_URL'] ?? 'http://localhost:3000';
    final url = Uri.parse('$baseUrl/product_view');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(
        {
          'id_product': productId, 
          'id_user': userId
        }
      ),
    );
    if (response.statusCode != 201) {
      throw Exception('Error al guardar la vista del producto');
    }
  }
}
