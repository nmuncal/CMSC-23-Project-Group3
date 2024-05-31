import 'package:cmsc_23_project_group3/providers/auth_provider.dart';
import 'package:cmsc_23_project_group3/providers/donation_provider.dart';
import 'package:cmsc_23_project_group3/providers/user_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class QRCodeScannerPage extends StatefulWidget {
  const QRCodeScannerPage({super.key});

  @override
  State<QRCodeScannerPage> createState() => _QRCodeScannerPageState();
}

class _QRCodeScannerPageState extends State<QRCodeScannerPage> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  QRViewController? controller;
  bool _isProcessing = false;

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  void _onQRViewCreated(QRViewController qrController) {
    setState(() {
      controller = qrController;
    });

    User? user = context.read<UserAuthProvider>().user;

    controller?.scannedDataStream.listen((scanData) {
      if (!_isProcessing) {
        _isProcessing = true;
        controller?.pauseCamera();
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Change Donation Status'),
            content: const Text(
                'Do you want to change the status of this donation to \'completed\'?'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  controller?.resumeCamera();
                  _isProcessing = false;
                },
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () async {
                  final donationProvider = context.read<DonationProvider>();

                  await donationProvider
                      .fetchDonationRecipient(scanData.code!)
                      .then((recipientId) {
                    if (recipientId == user!.uid) {
                      donationProvider
                          .fetchDonationStatus(scanData.code!)
                          .then((donationStatus) {
                        if (donationStatus != 'Completed') {
                          _updateDonationStatus(context, scanData.code!)
                              .then((_) {
                            Navigator.of(context).pop();
                            controller?.resumeCamera();
                            _isProcessing = false;
                          });
                        } else {
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: Text('Donation Status'),
                              content:
                                  Text('Donation status is already completed.'),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: const Text('OK'),
                                ),
                              ],
                            ),
                          );
                          Navigator.of(context).pop();
                          controller?.resumeCamera();
                          _isProcessing = false;
                        }
                      });
                    } else {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: Text('Donation Status'),
                          content: Text(
                              'Error: Not Found.'),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: const Text('OK'),
                            ),
                          ],
                        ),
                      );
                      Navigator.of(context).pop();
                      controller?.resumeCamera();
                      _isProcessing = false;
                    }
                  });
                },
                child: const Text('Confirm'),
              ),
            ],
          ),
        );
      }
    });
  }

  Future<void> _updateDonationStatus(
      BuildContext context, String scanDataCode) async {
    final donationProvider = context.read<DonationProvider>();
    await donationProvider
        .updateDonationStatus(scanDataCode, "Completed")
        .then((value) => showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: Text('Donation Status'),
                content: Text(value ?? 'Unknown error occurred.'),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text('OK'),
                  ),
                ],
              ),
            ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Scan QR Code'),
      ),
      body: QRView(
        key: qrKey,
        overlay: QrScannerOverlayShape(
            borderColor: Colors.red,
            borderRadius: 10,
            borderLength: 30,
            borderWidth: 10,
            cutOutSize: 250.0),
        onQRViewCreated: _onQRViewCreated,
      ),
    );
  }
}
