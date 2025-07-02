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

  //envia un mensaje, ubicacion iamgen o propuesta de intercambio a un chat, solo uno a la vez
  Future<void> sendMessage({
    required String productOwnerId,
    required String potBuyerId,
    required int productId,
    String? message,
    String? imagePath,
    int? idProduct, 
    double? latitudeSent,
    double? longitudeSent,
    String? productImage,
    required String senderId,
    required DateTime dateMessageSent,
  }) async {
    try {
      final chatId = "$productOwnerId$potBuyerId$productId";
      final newMessage = {
        'senderId': senderId,
        'dateMessageSent': Timestamp.fromDate(dateMessageSent),
        'message': idProduct == null ? message : null, 
        'imagePath': idProduct == null ? imagePath : null, 
        'latitudeSent': idProduct == null ? latitudeSent : null, 
        'longitudeSent': idProduct == null ? longitudeSent : null, 
        'idProduct': idProduct, 
        'productImage': productImage, 
        'accepted': null, 
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

  //obtiene todos los chats en los que participa un usuario especifico
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

  //obtiene los datos de un chat especifico
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

  //actualiza el estado de (aceptado o rechazado) de una propuesta de intercambio en un chat
  Future<void> updateExchangeStatus({
    required String productOwnerId,
    required String potBuyerId,
    required int productId,
    required int idProduct,
    required bool accepted,
  }) async {
    try {
      final chatId = "$productOwnerId$potBuyerId$productId";
      final chatDocRef = firestore.collection('chats').doc(chatId);
      final chatDoc = await chatDocRef.get();
      if (!chatDoc.exists) {
        throw Exception("El chat no existe");
      }
      final chatData = chatDoc.data();
      if (chatData == null || !chatData.containsKey('messages')) {
        throw Exception("El chat no tiene mensajes");
      }
      List<dynamic> messages = List.from(chatData['messages']);
      int index = messages.indexWhere((msg) => msg['idProduct'] == idProduct);
      if (index == -1) {
        throw Exception("No se ha encontrado el mensaje con el idProduct");
      }
      messages[index]['accepted'] = accepted;
      await chatDocRef.update({'messages': messages});
    } catch (e) {
      debugPrint("Error en updateExchangeStatus: $e");
      throw Exception("Error al actualizar el estado de intercambio");
    }
  }

  //elimina un chat o una propuesta de intercambio asociada a un producto
  Future<void> deleteChatAndExchangeProposal({
    required int productId,
  }) async {
    try {
      final chatCollection = await firestore.collection('chats').get();
      for (final doc in chatCollection.docs) {
        final data = doc.data();
        final docId = doc.id;
        if (data['productId'] == productId) {
          await firestore.collection('chats').doc(docId).delete();
        } else if (data['messages'] != null) {
          List<dynamic> messages = List.from(data['messages']);
          List<dynamic> updatedMessages = messages.where((msg) => msg['idProduct'] != productId).toList();
          if (updatedMessages.length != messages.length) {
            await firestore.collection('chats').doc(docId).update({'messages': updatedMessages});
          }
        }
      }
    } catch (e) {
      debugPrint("Error al eliminar chat o propuesta de intercambio: $e");
      throw Exception("No se pudo eliminar el chat o propuesta");
    }
  }

  //sube una imagen al servidor(mi backend) y devuelve la ruta donde fue almacenada
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

  //envia una notificacion a otro usuario cuando mandan algo al chat
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