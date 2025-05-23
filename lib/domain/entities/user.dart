class UserEntity {
  final String id;
  final String email;
  final String? name;
  final String? surname;
  final int? telNumber;
  final String? avatarId;
  final String? tokenNotifications;
  final DateTime? dateBirth; 
  final String? linkAvatar;
  final double? balance;
  final double? rating;
  final int? totalRating;

  UserEntity({
    required this.id,
    required this.email,
    this.name,
    this.surname,
    this.telNumber,
    this.avatarId,
    this.tokenNotifications,
    this.dateBirth,
    this.linkAvatar,
    this.balance,
    this.rating,
    this.totalRating,
  });
}
