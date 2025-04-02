import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:swapify/presentation/widgets/alertdialog_add_balance_user.dart';

//pagina que añade saldo a tu usuario(escaneando un qr creado por mi)
class QRScannerScreenAddBalance extends StatefulWidget {
  const QRScannerScreenAddBalance({super.key});

  @override
  State<QRScannerScreenAddBalance> createState() => _QRScannerScreenAddBalanceState();
}

class _QRScannerScreenAddBalanceState extends State<QRScannerScreenAddBalance> {
  bool cameraPermissionGranted = false;
  bool _isScanning = true;

  @override
  void initState() {
    super.initState();
    _requestCameraPermission();
  }

  //funcion que pide permisos de camara si no se han aceptado
  Future<void> _requestCameraPermission() async {
    final status = await Permission.camera.request();
    setState(() {
      cameraPermissionGranted = status.isGranted;
    });
    if (status.isPermanentlyDenied) {
      await openAppSettings();
    }
  }

  //funcion llaamada al escanear
  void _onQRCodeScanned(String? scannedCode) {
    if (_isScanning && scannedCode != null) {
      setState(() {
        _isScanning = false;
      });
      try {
        int balance = int.tryParse(scannedCode) ?? 0;
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Center(child: Text(AppLocalizations.of(context)!.addBalance)),
            content: AlertAddBallance(balance: balance),
          ),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error: $e")));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.areYouSureAddBalance),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            flex: 5,
            //si se han aceptado los permisos se abre el scanner
            child: cameraPermissionGranted
                ? MobileScanner(
                    fit: BoxFit.cover,
                    onDetect: (barcodeCapture) {
                      for (final barcode in barcodeCapture.barcodes) {
                        //si el qr no esta vacio
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
