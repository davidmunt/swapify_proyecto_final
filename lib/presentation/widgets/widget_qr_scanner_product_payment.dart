import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:swapify/presentation/widgets/alertdialog_sell_product.dart';

class QRScannerProductPayment extends StatefulWidget {
  const QRScannerProductPayment({super.key});

  @override
  State<QRScannerProductPayment> createState() => _QRScannerProductPaymentState();
}

class _QRScannerProductPaymentState extends State<QRScannerProductPayment> {
  bool cameraPermissionGranted = false;
  bool _isScanning = true;

  @override
  void initState() {
    super.initState();
    _requestCameraPermission();
  }

  Future<void> _requestCameraPermission() async {
    final status = await Permission.camera.request();
    setState(() {
      cameraPermissionGranted = status.isGranted;
    });
    if (status.isPermanentlyDenied) {
      await openAppSettings();
    }
  }

  void _onQRCodeScanned(String? scannedCode) {
    if (_isScanning && scannedCode != null) {
      setState(() {
        _isScanning = false;
      });
      try {
        final Map<String, dynamic> qrData = jsonDecode(scannedCode);
        final int productId = qrData['productId'];
        final String userId = qrData['userId'];
        if (productId != null && userId.isNotEmpty) {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Center(child: Text(AppLocalizations.of(context)!.confirmSell)),
              content: AlertSell(productId: productId, userId: userId),
            ),
          );
        } else {
          throw Exception(AppLocalizations.of(context)!.qrInvalid);
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error: $e")));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.all(10), 
      child: Container(
        padding: const EdgeInsets.all(12), 
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        height: 450, 
        width: 320, 
        child: Column(
          children: [
            Text(
              AppLocalizations.of(context)!.scanQRToConfirmSell,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Expanded(
              flex: 5,
              child: cameraPermissionGranted
                  ? MobileScanner(
                      fit: BoxFit.cover,
                      onDetect: (barcodeCapture) {
                        for (final barcode in barcodeCapture.barcodes) {
                          if (barcode.rawValue != null) {
                            _onQRCodeScanned(barcode.rawValue);
                            break;
                          }
                        }
                      },
                    )
                  : Center(child: Text(AppLocalizations.of(context)!.cameraNoAutorized)),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(AppLocalizations.of(context)!.cancel),
            ),
          ],
        ),
      ),
    );
  }
}
