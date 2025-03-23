import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' show jsonEncode;
import 'package:swapify/core/failure.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class RecomendationPriceDataSource {
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
      Basándote exclusivamente en datos actuales del año $currentYear, ¿cuál es el precio medio en el mercado para un producto con las siguientes características?

      Marca: $productBrand  
      Modelo: $productModel  
      Descripción: $description  
      Categoría: $productCategory  
      Estado: $productState  

      Considera solo productos reales y similares publicados a partir de enero de $currentYear.  
      Si no puedes encontrar ningún producto comparable válido o si los datos parecen irreales, devuelve exactamente el número **0.0**.  
      En todos los casos, devuelve únicamente un número decimal (por ejemplo: 59.99), sin símbolos de moneda ni palabras adicionales.
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
        throw Exception('No se pudo obtener un precio válido de la IA');
      }
      final double lowerLimit = recommendedPrice * 0.80;
      final double upperLimit = recommendedPrice * 1.20;
      if (price < lowerLimit || price > upperLimit) {
        return double.parse(recommendedPrice.toStringAsFixed(2));
      }
      return null;
    } catch (e) {
      debugPrint("Error en getRecomendationProductPrice: $e");
      throw ServerFailure();
    }
  }
}
