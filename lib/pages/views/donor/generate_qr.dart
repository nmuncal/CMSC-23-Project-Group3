import 'package:cmsc_23_project_group3/providers/donation_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:flutter/rendering.dart';
import 'dart:ui' as ui;
import 'dart:typed_data';
import 'package:intl/intl.dart';

class QRCodePage extends StatefulWidget {
  final String qrData;

  const QRCodePage({required this.qrData, super.key});

  @override
  State<QRCodePage> createState() => _QRCodePageState();
}

class _QRCodePageState extends State<QRCodePage> {
  final GlobalKey _qrKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<DonationProvider>(context, listen: false)
          .setDonationId(widget.qrData);
    });
  }

  Future<void> _saveQRCode() async {
    final permissionStatus = await Permission.storage.request();

    if (permissionStatus.isGranted) {
      try {
        RenderRepaintBoundary boundary =
            _qrKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
        var image = await boundary.toImage();
        ByteData? byteData =
            await image.toByteData(format: ui.ImageByteFormat.png);
        Uint8List pngBytes = byteData!.buffer.asUint8List();

        final recorder = ui.PictureRecorder();
        final canvas = Canvas(recorder);
        final paint = Paint();
        final imageSize = 300.0; 

        final originalImage = await decodeImageFromList(pngBytes);
        canvas.drawImage(originalImage, Offset.zero, paint);

        String status = Provider.of<DonationProvider>(context, listen: false)
            .donation!
            .status;
        String dateCreated = DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now());

        final textPainter = TextPainter(
          text: TextSpan(
            text: 'Status: $status\nDate: $dateCreated',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
            ),
          ),
          textDirection: ui.TextDirection.ltr, // Use ui.TextDirection.ltr here
        );
        textPainter.layout();
        textPainter.paint(canvas, Offset(10, imageSize + 10)); // Adjust the position as needed

        final picture = recorder.endRecording();
        final finalImage = await picture.toImage(
          imageSize.toInt(),
          (imageSize + textPainter.height + 20).toInt(), // Adjust the canvas height as needed
        );
        final byteDataFinal =
            await finalImage.toByteData(format: ui.ImageByteFormat.png);
        final pngBytesFinal = byteDataFinal!.buffer.asUint8List();

        final result = await ImageGallerySaver.saveImage(
            Uint8List.fromList(pngBytesFinal),
            quality: 100,
            name: "qr_code_with_text");

        String? filePath = result['filePath'];

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(result['isSuccess']
                ? 'QR Code saved to gallery! Path: $filePath'
                : 'Failed to save QR Code.'),
          ),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error occurred while saving the QR Code.'),
          ),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Permission denied. Unable to save QR Code.'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.qrData,
          style: TextStyle(color: Colors.black),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.save_alt),
            onPressed: _saveQRCode,
          ),
        ],
      ),
      body: Consumer<DonationProvider>(
        builder: (context, donationProvider, child) {
          if (donationProvider.donation != null &&
              donationProvider.donation!.status == 'Completed') {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text('Donation Completed'),
                    content: Text('Thank you for your donation!'),
                    actions: <Widget>[
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                          Navigator.pop(context);
                        },
                        child: Text('OK'),
                      ),
                    ],
                  );
                },
              );
            });
          }

          return Center(
            child: RepaintBoundary(
              key: _qrKey,
              child: QrImageView(
                data: widget.qrData,
                version: QrVersions.auto,
                errorCorrectionLevel: QrErrorCorrectLevel.H,
                size: 250,
                foregroundColor: Color(0xff405f7d),
                embeddedImage: AssetImage('lib/assets/ico_logo.png'),
                embeddedImageStyle: QrEmbeddedImageStyle(
                  size: Size(60, 60),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
