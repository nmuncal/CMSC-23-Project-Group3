import 'package:cmsc_23_project_group3/providers/donation_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';

class QRCodePage extends StatefulWidget {
  final String qrData;

  const QRCodePage({required this.qrData,super.key});

  @override
  State<QRCodePage> createState() => _QRCodePageState();
}

class _QRCodePageState extends State<QRCodePage> {
  @override
  void initState() {
    super.initState();
    // Set the donationId after the widget is initialized
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<DonationProvider>(context, listen: false)
          .setDonationId(widget.qrData);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.qrData,
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: Consumer<DonationProvider>(

        //close this page as soon as the status gets completed
        builder: (context, donationProvider, child) {
          if (donationProvider.donation != null && donationProvider.donation!.status == 'Completed') {
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
          );
        },
      ),
    );
  }
}
