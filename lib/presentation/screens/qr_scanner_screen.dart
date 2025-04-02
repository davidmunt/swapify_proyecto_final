import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:swapify/presentation/widgets/alertdialog_exchange_product.dart';
import 'package:swapify/presentation/widgets/alertdialog_sell_product.dart';

//pantalla que escane un qr para la compra o intercambio de un producto
class QRScannerScreen extends StatefulWidget {
  const QRScannerScreen({super.key});

  @override
  State<QRScannerScreen> createState() => _QRScannerScreenState();
}

class _QRScannerScreenState extends State<QRScannerScreen> {
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
        //si le llegan dos datos al escanear (id de tu producto y id del usuario comprador)
        if (qrData.length == 2){
          final int productId = qrData['productId'];
          final String userId = qrData['userId'];
          if (userId.isNotEmpty) {
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
        }
        //si le llegan tres datos al escanear (id de tu producto, id del producto a intermcabiar y id del usuario comprador)
        else if (qrData.length == 3){
          final int productId = qrData['productId'];
          final int producExchangedtId = qrData['productExchangedId'];
          final String userId = qrData['userId'];
          if (userId.isNotEmpty) {
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: Center(child: Text(AppLocalizations.of(context)!.confirmSell)),
                content: AlertExchange(productId: productId, producExchangedtId: producExchangedtId, userId: userId),
              ),
            );
          } else {
            throw Exception(AppLocalizations.of(context)!.qrInvalid);
          }
        }
        
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error: $e")));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.scanQRToConfirmSell),
        centerTitle: true,
      ),
      body: Column(
        children: [
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
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(AppLocalizations.of(context)!.cancel),
            ),
          ),
        ],
      ),
    );
  }
}
