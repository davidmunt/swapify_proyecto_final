import 'package:flutter/material.dart';
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

class FirebaseAuthDataSource {
  final FirebaseAuth auth;
  final FirebaseFirestore firestore;

  FirebaseAuthDataSource({required this.auth, required this.firestore});

  Future<UserModel> signIn(String email, String password) async {
    UserCredential userCredentials = await auth.signInWithEmailAndPassword(email: email, password: password);
    
    return UserModel.fromUserCredential(userCredentials);
  }

  Future<void> resetPassword(String email) async {
    try {
      await auth.sendPasswordResetEmail(email: email);
    } catch (e) {
      debugPrint("Error al enviar el correo: $e");
    }
  }

  Future<void> saveUserInfoToBackend({
    required String uid,
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

  Future<void> changeUserInfoToBackend({
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
        headers: {'Content-Type': 'application/json'},
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

  Future<void> saveUserNotificationToken({
    required String userId,
    required String? notificationToken,
  }) async {
    try {
      final baseUrl = dotenv.env['BASE_API_URL'] ?? 'http://localhost:3000';
      final url = Uri.parse('$baseUrl/user/$userId');
      final response = await http.put(
        url,
        headers: {'Content-Type': 'application/json'},
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

  Future<Map<String, dynamic>> getUserInfo(String uid) async {
    try {
      final baseUrl = dotenv.env['BASE_API_URL'] ?? 'http://localhost:3000';
      final url = Uri.parse('$baseUrl/user/$uid');
      final response = await http.get(url, headers: {'Content-Type': 'application/json'});
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

  Future<List<Map<String, dynamic>>> getUsersInfo() async {
    try {
      final baseUrl = dotenv.env['BASE_API_URL'] ?? 'http://localhost:3000';
      final url = Uri.parse('$baseUrl/user');
      final response = await http.get(url, headers: {'Content-Type': 'application/json'});
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

  Future<void> changeUserAvatar({
    required String uid,
    required XFile image,
  }) async {
    try {
      final baseUrl = dotenv.env['BASE_API_URL'] ?? 'http://localhost:3000';
      final url = Uri.parse('$baseUrl/upload');
      final request = http.MultipartRequest('POST', url);
      request.files.add(await http.MultipartFile.fromPath('file', image.path));
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

  Future<void> deleteUserFromBackend(String id) async {
    try {
      final baseUrl = dotenv.env['BASE_API_URL'] ?? 'http://localhost:3000';
      final url = Uri.parse('$baseUrl/user/$id');
      final response = await http.delete(url, headers: {'Content-Type': 'application/json'});
      if (response.statusCode != 200) {
        throw Exception('Error al eliminar el usuario del backend');
      }
    } catch (e) {
      debugPrint("Error en deleteUserFromBackend: $e");
      throw Exception("Error al eliminar el usuario del backend");
    }
  }

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

  Future<void> signUp(String email, String password) async {
    try {
      await auth.createUserWithEmailAndPassword(email: email, password: password);
    } catch (e) {
      debugPrint("Error en el registro: $e");
    }
  }

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

  Future<void> logout() async {
    await auth.signOut();
  }

  String? getCurrentUser() {
    final user = auth.currentUser;
    return user?.email;
  }
}