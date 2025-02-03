import 'package:swapify/domain/entities/qr.dart';

class QRModel {
  final String qrPath;

  QRModel({required this.qrPath});

  factory QRModel.fromMap(Map<String, dynamic> map) {
    return QRModel(
      qrPath: map['qrPath'],
    );
  }

  QREntity toEntity() {
    return QREntity(
      qrPath: qrPath,
    );
  }
}
