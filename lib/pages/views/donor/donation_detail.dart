import 'package:cmsc_23_project_group3/models/donation_model.dart';
import 'package:cmsc_23_project_group3/pages/views/donor/generate_qr.dart';
import 'package:cmsc_23_project_group3/providers/donation_provider.dart';
import 'package:cmsc_23_project_group3/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cmsc_23_project_group3/styles.dart';
import 'package:google_fonts/google_fonts.dart';

class DonationDetailPage extends StatefulWidget {
  final Donation? donation;

  const DonationDetailPage({this.donation});

  @override
  _DonationDetailPageState createState() => _DonationDetailPageState();
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
      appBar: _buildAppBar(context, Text(
        'tayo',
        style: GoogleFonts.quicksand(
          color: Styles.mainBlue,
          fontWeight: FontWeight.bold,
          fontSize: 30,
        ),
      ),),
      body: Consumer2<DonationProvider, UserProvider>(
        builder: (context, donationProvider, userProvider, child) {
          final donation = donationProvider.donation;
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: donation != null
                  ? Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Center(
                    child: Text(
                      donation.id,
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Column(
                        children: [
                          Icon(Icons.person, size: 30),
                          FutureBuilder<String?>(
                            future: userProvider.getUsernameByUid(donation.donorId),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState == ConnectionState.waiting) {
                                return Text('Loading...');
                              } else if (snapshot.hasError) {
                                return Text('Error loading username');
                              } else {
                                return Text(snapshot.data ?? 'Unknown');
                              }
                            },
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          Icon(Icons.arrow_forward, size: 30),
                        ],
                      ),
                      Column(
                        children: [
                          Icon(Icons.person, size: 30),
                          FutureBuilder<String?>(
                            future: userProvider.getUsernameByUid(donation.recipientId),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState == ConnectionState.waiting) {
                                return Text('Loading...');
                              } else if (snapshot.hasError) {
                                return Text('Error loading username');
                              } else {
                                return Text(snapshot.data ?? 'Unknown');
                              }
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Text(
                          donation.status,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Donated Items:',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 10),
                  Wrap(
                    alignment: WrapAlignment.center,
                    spacing: 8.0,
                    children: donation.donatedItems.map((item) {
                      return Chip(
                        label: Text(item),
                        backgroundColor: Styles.mainBlue.withOpacity(0.1),
                      );
                    }).toList(),
                  ),
                  SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          'Item Photo:',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 10),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(15),
                          child: SizedBox(
                            width: 200,
                            height: 200,
                            child: GestureDetector(
                              onTap: () {
                                // Show full photo
                              },
                              child: CachedNetworkImage(
                                imageUrl: donation.url,
                                placeholder: (context, url) => CircularProgressIndicator(),
                                errorWidget: (context, url, error) => Icon(Icons.error),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Weight: ${donation.weight} KG',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 20),
                  if (donation.isPickup) ...[
                    SizedBox(height: 20),
                    Text(
                      'Contact Number:',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      donation.contactNumber,
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Addresses:',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 5),
                    Text(
                      donation.addressForPickup.join(', '),
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                    SizedBox(height: 20),
                    generateQrCode(donation.id),
                  ],
                  SizedBox(height: 20),
if (donation.status == 'Pending')
  ElevatedButton(
    onPressed: () async {
      String? message = await donationProvider.updateDonationStatus(donation.id,"Cancelled");
      if (message != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(message)),
        );
      }
    },
    child: Text('Cancel Donation'),
    style: ElevatedButton.styleFrom(
      // Add styling here if needed
    ),
  ),

                ],
              )
                  : Center(child: CircularProgressIndicator()),
            ),
          );
        },
      ),
    );
  }

  Widget generateQrCode(String donationId) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(vertical: 20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Styles.mainBlue, Styles.darkerGray],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.circular(30),
      ),
      child: TextButton(
        onPressed: () async {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => QRCodePage(qrData: donationId),
            ),
          );
        },
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 16),
          child: Text(
            'Generate QR Code',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  AppBar _buildAppBar(BuildContext context, Text titleText) {
    return AppBar(
      centerTitle: true,
      title: titleText,
      leading: IconButton(
        icon: Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Styles.mainBlue.withOpacity(0.1), // Circle background with some transparency
          ),
          child: Icon(
            Icons.arrow_back,
            color: Styles.mainBlue,
          ),
        ),
        onPressed: () {
          Navigator.of(context).pop();
        },
      ),
      automaticallyImplyLeading: false,
    );
  }
}
