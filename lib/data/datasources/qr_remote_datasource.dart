import 'package:http/http.dart' as http;
import 'dart:convert' show jsonDecode, jsonEncode;
import 'package:swapify/core/failure.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class QRDataSource {
  Future<String> getQRProductPayment({
    required String userId,
    required int productId,
  }) async {
    try {
      final baseUrl = dotenv.env['BASE_API_URL'] ?? 'http://localhost:3000';
      final url = Uri.parse('$baseUrl/upload/generate-qr');
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          "userId": userId,
          "productId": productId
        }),
      );
      if (response.statusCode != 201) {
        throw Exception('Error al conseguir el QR para el pago del producto');
      }
      final data = jsonDecode(response.body);
      return data['qrPath'];
    } catch (e) {
      throw ServerFailure();
    }
  }

  Future<String> getQRProductExchange({
    required String userId,
    required int productId,
    required int productExchangedId,
  }) async {
    try {
      final baseUrl = dotenv.env['BASE_API_URL'] ?? 'http://localhost:3000';
      final url = Uri.parse('$baseUrl/upload/generate-qr-exchange');
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          "userId": userId,
          "productId": productId,
          "productExchangedId": productExchangedId
        }),
      );
      if (response.statusCode != 201) {
        throw Exception('Error al conseguir el QR para el intercambio del producto');
      }
      final data = jsonDecode(response.body);
      return data['qrPath'];
    } catch (e) {
      throw ServerFailure();
    }
  }
}
