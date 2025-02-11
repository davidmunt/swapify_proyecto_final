import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' show jsonDecode, jsonEncode;
import 'package:swapify/core/failure.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ChatDataSource {
  final FirebaseFirestore firestore;

  ChatDataSource({required this.firestore});

  Future<void> sendMessage({
    required String productOwnerId,
    required String potBuyerId,
    required int productId,
    String? message,
    String? imagePath,
    required String senderId,
    required DateTime dateMessageSent,
  }) async {
    try {
      final chatId = "$productOwnerId$potBuyerId$productId";
      final newMessage = {
        'senderId': senderId,
        'dateMessageSent': Timestamp.fromDate(dateMessageSent),
        'message': message,
        'imagePath': imagePath,
      };
      final chatDocRef = firestore.collection('chats').doc(chatId);
      final chatDoc = await chatDocRef.get();
      if (chatDoc.exists) {
        await chatDocRef.update({'messages': FieldValue.arrayUnion([newMessage])});
      } else {
        await chatDocRef.set({
          'productOwnerId': productOwnerId,
          'potBuyerId': potBuyerId,
          'productId': productId,
          'participants': [productOwnerId, potBuyerId],
          'messages': [newMessage],
        });
      }
    } catch (e) {
      debugPrint("Error en sendMessage: $e");
      throw Exception("Error al enviar el mensaje");
    }
  }

  Future<List<Map<String, dynamic>>> getMyChats({required String userId}) async {
    try {
      final query = await firestore.collection('chats')
        .where('participants', arrayContains: userId)
        .get();
      final chats = query.docs.map((doc) {
        final data = doc.data();
        data['id'] = doc.id;
        return data;
      }).toList();
      chats.sort((a, b) {
        final lastDateA = (a['messages']?.last['dateMessageSent'] as Timestamp?)?.toDate() ?? DateTime(0);
        final lastDateB = (b['messages']?.last['dateMessageSent'] as Timestamp?)?.toDate() ?? DateTime(0);
        return lastDateB.compareTo(lastDateA);
      });
      return chats;
    } catch (e) {
      debugPrint("Error en getMyChats: $e");
      throw Exception("Error al obtener los chats del usuario");
    }
  }

  Future<Map<String, dynamic>?> getChat(String chatId) async {
    try {
      final chatDoc = await firestore.collection('chats').doc(chatId).get();
      if (chatDoc.exists) {
        return chatDoc.data();
      }
      return null;
    } catch (e) {
      debugPrint("Error en getChat: $e");
      throw Exception("Error al obtener el chat");
    }
  }

  Future<String> uploadMessageImage({
    required XFile image,
  }) async {
    try {
      final baseUrl = dotenv.env['BASE_API_URL'] ?? 'http://localhost:3000';
      final url = Uri.parse('$baseUrl/upload/chat');
      final request = http.MultipartRequest('POST', url);
      if (kIsWeb) {
        final bytes = await image.readAsBytes();
        request.files.add(http.MultipartFile.fromBytes('file', bytes, filename: image.name));
      } else {
        request.files.add(await http.MultipartFile.fromPath('file', image.path));
      }
      final response = await request.send();
      if (response.statusCode == 200 || response.statusCode == 201) {
        final responseBody = await response.stream.bytesToString();
        final decodedResponse = jsonDecode(responseBody) as Map<String, dynamic>;
        final path = decodedResponse['files']['path'] as String;
        return path;
      } else {
        throw Exception('Error al subir la imagen del mensaje');
      }
    } catch (e) {
      debugPrint("Error en uploadMessageImage: $e");
      throw ServerFailure();
    }
  }

  Future<void> sendNotificationToOtherUser({
    required int productId,
    required String? text,
    required String sender,
    required String reciver,
  }) async {
    try {
      final baseUrl = dotenv.env['BASE_API_URL'] ?? 'http://localhost:3000';
      final url = Uri.parse('$baseUrl/message');
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          "productId": productId,
          "text": text,
          "sender": sender,
          "reciver": reciver,
        }),
      );
      if (response.statusCode != 201) {
        throw Exception('Error al enviar la notifiacion al otro usuario');
      }
    } catch (e) {
      throw ServerFailure();
    }
  }
}