import 'package:flutter/material.dart';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:swapify/data/models/user_model.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' show jsonDecode, jsonEncode;
import 'package:swapify/core/failure.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http_parser/http_parser.dart';

class FirebaseAuthDataSource {
  final FirebaseAuth auth;
  final FirebaseFirestore firestore;

  FirebaseAuthDataSource({required this.auth, required this.firestore});

  //inicia sesion con email y contraseña usando Firebase Auth
  Future<UserModel> signIn(String email, String password) async {
    UserCredential userCredentials = await auth.signInWithEmailAndPassword(email: email, password: password);
    
    return UserModel.fromUserCredential(userCredentials);
  }

  //envia un correo para restablecer la contraseña del usuario
  Future<void> resetPassword(String email) async {
    try {
      await auth.sendPasswordResetEmail(email: email);
    } catch (e) {
      debugPrint("Error al enviar el correo: $e");
    }
  }

  //guarda la informacion del usuario al backend
  Future<void> saveUserInfoToBackend({
    required String uid,
    required String password,
    required String name,
    required String surname,
    required String email,
    required int telNumber,
    required DateTime dateBirth,
  }) async {
    try {
      final baseUrl = dotenv.env['BASE_API_URL'] ?? 'http://localhost:3000';
      final url = Uri.parse('$baseUrl/user');
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          "id_user": uid,
          "password": password,
          "name": name,
          "surname": surname,
          "telNumber": telNumber.toString(),
          "email": email,
          "dateBirth": dateBirth.toIso8601String(),
        }),
      );
      if (response.statusCode != 201 && response.statusCode != 200) {
        throw Exception('Error al guardar la informacion en el backend');
      }
    } catch (e) {
      throw ServerFailure();
    }
  }

  //hace el login al backend y obtiene el token
  Future<String> loginToGetTokenFromBackend({
    required String email,
    required String password,
  }) async {
    try {
      final baseUrl = dotenv.env['BASE_API_URL'] ?? 'http://localhost:3000';
      final url = Uri.parse('$baseUrl/auth/login');
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          "email": email,
          "password": password,
        }),
      );
      if (response.statusCode != 201) {
        throw Exception('Error al hacer login en el backend');
      }else {
        final responseData = jsonDecode(response.body);
        print(responseData['access_token'] as String);
        return responseData['access_token'] as String;
      }
    } catch (e) {
      throw ServerFailure();
    }
  }

  //actualiza la informacion del usuario en el backend
  Future<void> changeUserInfoToBackend({
    required String token,
    required String uid,
    required String name,
    required String surname,
    required int telNumber,
    required DateTime dateBirth,
  }) async {
    try {
      final baseUrl = dotenv.env['BASE_API_URL'] ?? 'http://localhost:3000';
      final url = Uri.parse('$baseUrl/user/$uid');
      final response = await http.put(
        url,
        headers: {'Authorization': 'Bearer $token', 'Content-Type': 'application/json'},
        body: jsonEncode({
          "name": name,
          "surname": surname,
          "telNumber": telNumber.toString(),
          "dateBirth": dateBirth.toIso8601String(),
        }),
      );
      if (response.statusCode != 201 && response.statusCode != 200) {
        throw Exception('Error al guardar la informacion en el backend');
      }
    } catch (e) {
      throw ServerFailure();
    }
  }

  //guarda el token de notificaciones push del usuario en el backend
  Future<void> saveUserNotificationToken({
    required String token,
    required String userId,
    required String? notificationToken,
  }) async {
    try {
      final baseUrl = dotenv.env['BASE_API_URL'] ?? 'http://localhost:3000';
      final url = Uri.parse('$baseUrl/user/$userId');
      final response = await http.put(
        url,
        headers: {'Authorization': 'Bearer $token', 'Content-Type': 'application/json'},
        body: jsonEncode({
          "tokenNotifications": notificationToken
        }),
      );
      if (response.statusCode != 200) {
        throw Exception('Error al guardar el token de las notificaciones de ese usuario');
      }
    } catch (e) {
      throw ServerFailure();
    }
  }

  //obtiene la informacion del usuario desde el backend
  Future<Map<String, dynamic>> getUserInfo(String uid, String token) async {
    try {
      final baseUrl = dotenv.env['BASE_API_URL'] ?? 'http://localhost:3000';
      final url = Uri.parse('$baseUrl/user/$uid');
      final response = await http.get(url, headers: {'Authorization': 'Bearer $token', 'Content-Type': 'application/json'});
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Error al obtener la información del usuario');
      }
    } catch (e) {
      debugPrint("Error en getUserInfo: $e");
      throw ServerFailure();
    }
  }
  
  //obtiene la lista de todos los usuarios desde el backend
  Future<List<Map<String, dynamic>>> getUsersInfo(String token) async {
    try {
      final baseUrl = dotenv.env['BASE_API_URL'] ?? 'http://localhost:3000';
      final url = Uri.parse('$baseUrl/user');
      final response = await http.get(url, headers: {'Authorization': 'Bearer $token', 'Content-Type': 'application/json'});
      if (response.statusCode == 200) {
        return List<Map<String, dynamic>>.from(jsonDecode(response.body));
      } else {
        throw Exception('Error al obtener la información de los usuarios');
      }
    } catch (e) {
      debugPrint("Error en getUsersInfo: $e");
      throw ServerFailure();
    }
  }

  //obtiene el link de la imagen del avatar del usuario
  Future<String?> getLinkUserAvatar(String avatarId) async {
    try {
      final baseUrl = dotenv.env['BASE_API_URL'] ?? 'http://localhost:3000';
      final url = Uri.parse('$baseUrl/upload/$avatarId');
      final response = await http.get(url, headers: {'Content-Type': 'application/json'});
      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        return responseData['link'] as String?;
      } else {
        debugPrint("Error al obtener el link del avatar: ${response.statusCode}");
        return null;
      }
    } catch (e) {
      debugPrint("Error en getLinkUserAvatar: $e");
      return null;
    }
  }

  //modifica el avatar del usuario
  Future<void> changeUserAvatar({
    required String uid,
    required XFile image,
  }) async {
    try {
      final baseUrl = dotenv.env['BASE_API_URL'] ?? 'http://localhost:3000';
      final url = Uri.parse('$baseUrl/upload');
      final request = http.MultipartRequest('POST', url);
      if (kIsWeb) {
        Uint8List imageBytes = await image.readAsBytes();
        request.files.add(http.MultipartFile.fromBytes(
          'file',
          imageBytes,
          filename: 'avatar.png', 
          contentType: MediaType('image', 'png'),
        ));
      } else {
        request.files.add(await http.MultipartFile.fromPath('file', image.path));
      }
      request.fields['id_user'] = uid;
      final response = await request.send();
      if (response.statusCode != 200 && response.statusCode != 201) {
        throw Exception('Error al subir el avatar del usuario');
      }
    } catch (e) {
      debugPrint("Error en changeUserAvatar: $e");
      throw ServerFailure();
    }
  }

  //cambia la contraseña del usuario en Firebase
  Future<void> changePassword(String password) async {
    try {
      final user = auth.currentUser;
      if (user != null) {
        await user.updatePassword(password);
        debugPrint("Contraseña actualizada exitosamente.");
      } else {
        debugPrint("No hay un usuario autenticado.");
      }
    } catch (e) {
      debugPrint("Error al cambiar la contraseña: $e");
    }
  }

  //elimina al usuario desde Firebase Auth
  Future<void> deleteFirebaseUser() async {
    try {
      final user = auth.currentUser;
      if (user != null) {
        await user.delete();
        debugPrint("Usuario eliminado de Firebase");
      } else {
        throw Exception("No hay un usuario autenticado");
      }
    } catch (e) {
      debugPrint("Error al eliminar el usuario de Firebase: $e");
      throw Exception("Error al eliminar el usuario de Firebase");
    }
  }

  //elimina al usuario desde el backend
  Future<void> deleteUserFromBackend(String id, String token) async {
    try {
      final baseUrl = dotenv.env['BASE_API_URL'] ?? 'http://localhost:3000';
      final url = Uri.parse('$baseUrl/user/$id');
      final response = await http.delete(url, headers: {'Authorization': 'Bearer $token', 'Content-Type': 'application/json'});
      if (response.statusCode != 200) {
        throw Exception('Error al eliminar el usuario del backend');
      }
    } catch (e) {
      debugPrint("Error en deleteUserFromBackend: $e");
      throw Exception("Error al eliminar el usuario del backend");
    }
  }

  //guarda la informacion del usuario en Firestore(ya no la utilizo)
  Future<void> saveUserInfo({
    required String uid,
    required String name,
    required String surname,
    required String email,
    required int telNumber,
    required DateTime dateBirth,
  }) async {
    await firestore.collection('users').doc(uid).set({
      'name': name,
      'surname': surname,
      'email': email,
      'telNumber': telNumber,
      'dateBirth': Timestamp.fromDate(dateBirth),
    });
  }

  //registra un nuevo usuario en Firebase Auth
  Future<void> signUp(String email, String password) async {
    try {
      await auth.createUserWithEmailAndPassword(email: email, password: password);
    } catch (e) {
      debugPrint("Error en el registro: $e");
    }
  }

  
  //inicia sesion con Google
  Future<UserModel> signInWithGoogle() async {
    if (kIsWeb) {
      GoogleAuthProvider googleProvider = GoogleAuthProvider();
      UserCredential userCredentials = await FirebaseAuth.instance.signInWithPopup(googleProvider);
      return UserModel.fromUserCredential(userCredentials);
    } else {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );
      UserCredential userCredentials = await FirebaseAuth.instance.signInWithCredential(credential);
      return UserModel.fromUserCredential(userCredentials);
    }
  }

  //cierra sesion del usuario en Firebase Auth
  Future<void> logout() async {
    await auth.signOut();
  }

  //devuelve el email del usuario autenticado actual
  String? getCurrentUser() {
    final user = auth.currentUser;
    return user?.email;
  }

  //añade saldo a la cuenta del usuario en el backend
  Future<void> addBalanceToUser({
    required String userId,
    required int balanceToAdd,
    required String token,
  }) async {
    try {
      final baseUrl = dotenv.env['BASE_API_URL'] ?? 'http://localhost:3000';
      final url = Uri.parse('$baseUrl/user/addBallance');
      final response = await http.post(
        url,
        headers: {'Authorization': 'Bearer $token', 'Content-Type': 'application/json'},
        body: jsonEncode({
          "id_user": userId,
          "balance": balanceToAdd,
        }),
      );
      if (response.statusCode != 201) {
        throw Exception('Error al añadir el saldo al usuario');
      }
    } catch (e) {
      throw ServerFailure();
    }
  }

  //cambia la contraseña del usuario desde el backend
  Future<void> changeUserPassword({
    required String userId,
    required String password,
    required String token,
  }) async {
    try {
      final baseUrl = dotenv.env['BASE_API_URL'] ?? 'http://localhost:3000';
      final url = Uri.parse('$baseUrl/user/changePassword');
      final response = await http.post(
        url,
        headers: {'Authorization': 'Bearer $token', 'Content-Type': 'application/json'},
        body: jsonEncode({
          "id_user": userId,
          "newPassword": password,
        }),
      );
      if (response.statusCode != 201) {
        throw Exception('Error al cambiar la contraseña del usuario');
      }
    } catch (e) {
      throw ServerFailure();
    }
  }

  //añade una valoracion al usuario despues de una compra o intercambio de producto
  Future<void> addRatingToUser({
    required String userId,
    required String customerId,
    required int productId,
    required int rating,
    required String token,
  }) async {
    try {
      final baseUrl = dotenv.env['BASE_API_URL'] ?? 'http://localhost:3000';
      final url = Uri.parse('$baseUrl/user/addRating');
      final response = await http.post(
        url,
        headers: {'Authorization': 'Bearer $token', 'Content-Type': 'application/json'},
        body: jsonEncode({
          "id_user": userId, 
          "id_customer": customerId,
          "id_product": productId,
          "rating": rating,
        }),
      );
      if (response.statusCode != 201) {
        throw Exception('Error al añadir la valoracion al usuario');
      }
    } catch (e) {
      throw ServerFailure();
    }
  }
}