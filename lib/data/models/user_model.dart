import 'package:firebase_auth/firebase_auth.dart';
import 'package:swapify/domain/entities/user.dart';

class UserModel {
  final String id;
  final String email;
  final String? name;
  final String? surname;
  final int? telNumber; 
  final String? avatarId;
  final String? tokenNotifications;
  final DateTime? dateBirth;
  final String? linkAvatar;

  UserModel({
    required this.id,
    required this.email,
    this.name,
    this.surname,
    this.telNumber,
    this.avatarId,
    this.tokenNotifications,
    this.dateBirth,
    this.linkAvatar,
  });

  static UserModel fromUserCredential(UserCredential userCredentials) {
    return UserModel(
      id: userCredentials.user?.uid ?? "NO_ID",
      email: userCredentials.user?.email ?? "NO_EMAIL",
    );
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id_user'] ?? "NO_ID",
      email: map['email'] ?? "NO_EMAIL",
      name: map['name'],
      surname: map['surname'],
      telNumber: map['telNumber'] is int ? map['telNumber'] : int.tryParse(map['telNumber']?.toString() ?? '0'),
      avatarId: map['avatar_id']?.toString(),
      tokenNotifications: map['tokenNotifications'],
      dateBirth: map['dateBirth'] != null ? DateTime.tryParse(map['dateBirth']) : null,
    );
  }

  UserModel copyWith({
    String? linkAvatar,
  }) {
    return UserModel(
      id: id,
      email: email,
      name: name,
      surname: surname,
      telNumber: telNumber,
      tokenNotifications: tokenNotifications,
      avatarId: avatarId,
      dateBirth: dateBirth,
      linkAvatar: linkAvatar ?? this.linkAvatar,
    );
  }

  UserEntity toEntity() {
    return UserEntity(
      id: id,
      email: email,
      name: name,
      surname: surname,
      telNumber: telNumber,
      avatarId: avatarId,
      tokenNotifications: tokenNotifications,
      dateBirth: dateBirth,
      linkAvatar: linkAvatar,
    );
  }
}
