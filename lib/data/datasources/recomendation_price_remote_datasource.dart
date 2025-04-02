import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' show jsonEncode;
import 'package:swapify/core/failure.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class RecomendationPriceDataSource {
  //funcion que consulta una IA para recomendar precios para los productos
  Future<double?> getRecomendationProductPrice({
    required String productBrand,
    required String productModel,
    required String description,
    required double price,
    required String productCategory,
    required String productState,
  }) async {
    try {
      final String pollinationsApiUrl = dotenv.env['POLLINATIONS_API_URL'] ?? '';
      if (pollinationsApiUrl.isEmpty) {
        throw Exception('La URL de la API de Pollinations no está definida.');
      }
      final DateTime now = DateTime.now();
      final int currentYear = now.year;
      final String prompt = '''
      Basándote en información actual y real del año $currentYear, estima el precio medio de mercado para un producto de segunda mano con las siguientes características:

      Marca: $productBrand  
      Modelo: $productModel  
      Descripción: $description  
      Categoría: $productCategory  
      Estado: $productState

      Ten en cuenta que, aunque el estado sea "$productState", se trata de un producto de segunda mano y debe valorarse como tal. Considera referencias reales de plataformas de compra-venta, anuncios recientes y tiendas online de segunda mano.

      Devuelve exclusivamente un número decimal que represente el precio estimado (por ejemplo: 749.99). No incluyas símbolos de moneda, palabras, unidades ni explicaciones adicionales. Solo el número.
      ''';
      final response = await http.post(
        Uri.parse(pollinationsApiUrl),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          "messages": [
            {"role": "user", "content": prompt}
          ],
          "model": "openai",
          "private": true,
        }),
      );
      if (response.statusCode != 200) {
        throw Exception('Error en la API de Pollinations');
      }
      final String responseBody = response.body.trim();
      final double? recommendedPrice = double.tryParse(responseBody);
      if (recommendedPrice == null) {
        throw Exception('No se pudo obtener un precio valido de la IA');
      }
      final double finalPrice = recommendedPrice * 0.95;
      final double lowerLimit = finalPrice * 0.80;
      final double upperLimit = finalPrice * 1.20;
      if (price < lowerLimit || price > upperLimit) {
        return double.parse(finalPrice.toStringAsFixed(2));
      }
      return null;
    } catch (e) {
      debugPrint("Error en getRecomendationProductPrice: $e");
      throw ServerFailure();
    }
  }
}
