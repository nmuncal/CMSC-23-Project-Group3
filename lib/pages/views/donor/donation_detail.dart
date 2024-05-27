import 'package:cmsc_23_project_group3/models/donation_model.dart';
import 'package:cmsc_23_project_group3/pages/views/donor/generate_qr.dart';
import 'package:cmsc_23_project_group3/providers/donation_provider.dart';
import 'package:cmsc_23_project_group3/styles.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


class DonationDetailPage extends StatefulWidget {
  final Donation? donation;

  const DonationDetailPage({super.key, this.donation});

  @override
  State<DonationDetailPage> createState() => _DonationDetailPageState();
}

class _DonationDetailPageState extends State<DonationDetailPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<DonationProvider>(context, listen: false)
          .setDonationId(widget.donation!.id);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text('${widget.donation!.id}'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        backgroundColor: Colors.transparent,
        centerTitle: true,
      ),
      body: Consumer<DonationProvider>(
        builder: (context, donationProvider, child) {
          return Stack(
            children: [
             Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
        child: Align(
            alignment: Alignment.bottomCenter,
            child: (widget.donation!.isPickup && donationProvider.donation != null && donationProvider.donation!.status != 'Completed')
                ? generateQrCode(widget.donation!.id)
                : Container()),
      ),]
          );
        },
      ),
    );
  }

  Widget generateQrCode(String donationId) {
    return GestureDetector(
      child: Styles.gradientButtonBuilder(
          'Generate QR Code'), 
      onTap: () async {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => QRCodePage(qrData: donationId),
          ),
        );
      },

    );
  }
}
