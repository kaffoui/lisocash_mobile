import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:noyaux/constants/constants.dart';
import 'package:noyaux/constants/styles.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class AppScanQrCodePage extends StatefulWidget {
  final String type_transfert;
  const AppScanQrCodePage({super.key, required this.type_transfert});

  @override
  State<AppScanQrCodePage> createState() => _AppScanQrCodePageState();
}

class _AppScanQrCodePageState extends State<AppScanQrCodePage> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');

  Barcode? result;

  QRViewController? controller;

  Widget _buildQrView(BuildContext context) {
    // For this example we check how width or tall the device is and change the scanArea and overlay accordingly.
    var scanArea = 250.0;
    // To ensure the Scanner view is properly sizes after rotation
    // we need to listen for Flutter SizeChanged notification and update controller
    return QRView(
      key: qrKey,
      onQRViewCreated: _onQRViewCreated,
      overlay: QrScannerOverlayShape(borderColor: Colors.red, borderRadius: 10, borderLength: 30, borderWidth: 10, cutOutSize: scanArea),
      onPermissionSet: (ctrl, p) => _onPermissionSet(context, ctrl, p),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    setState(() {
      this.controller = controller;
    });
    controller.scannedDataStream.listen((scanData) {
      setState(() {
        result = scanData;
      });

      if (result != null) {
        print("res: ${result?.code}");
        setState(() {
          controller.pauseCamera();
        });
      }
    });
  }

  void _onPermissionSet(BuildContext context, QRViewController ctrl, bool p) {
    log('${DateTime.now().toIso8601String()}_onPermissionSet $p');
    if (!p) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('no Permission')),
      );
    }
  }

  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller!.pauseCamera();
    }
    controller!.resumeCamera();
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          "${widget.type_transfert}".toCapitalizedCase(),
          style: Style.defaultTextStyle(),
        ),
      ),
      body: Column(
        children: <Widget>[
          Container(
            height: 120,
            child: widget.type_transfert == TYPE_OPERATION.RETRAIT.name.toLowerCase()
                ? Container(
                    padding: EdgeInsets.all(12.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            "Scanner le code QR qui s'affichera sur le télephone de l'agent.",
                            textAlign: TextAlign.center,
                            style: Style.defaultTextStyle(
                              textSize: 16.0,
                              textWeight: FontWeight.w600,
                              textOverflow: null,
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                : Container(),
          ),
          Expanded(
            child: _buildQrView(context),
          )
        ],
      ),
    );
  }
}
