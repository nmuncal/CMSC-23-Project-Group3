import 'package:cmsc_23_project_group3/models/donation_model.dart';
import 'package:cmsc_23_project_group3/pages/views/donor/generate_qr.dart';
import 'package:cmsc_23_project_group3/providers/donation_provider.dart';
import 'package:cmsc_23_project_group3/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart'; // Import the package
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart'; // Import the package

class DonationDetailPage extends StatefulWidget {
  final Donation? donation;

  const DonationDetailPage({Key? key, this.donation}) : super(key: key);

  @override
  _DonationDetailPageState createState() => _DonationDetailPageState();
}

class _DonationDetailPageState extends State<DonationDetailPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      Provider.of<DonationProvider>(context, listen: false)
          .setDonationId(widget.donation!.id);
    });
  }

@override
Widget build(BuildContext context) {
  return Scaffold(
    extendBodyBehindAppBar: true,
    appBar: AppBar(
      title: Text('Donation Details'),
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.black),
        onPressed: () {
          Navigator.of(context).pop();
        },
      ),
      backgroundColor: Colors.transparent,
      centerTitle: true,
    ),
    body: Consumer2<DonationProvider, UserProvider>(
      builder: (context, donationProvider, userProvider, child) {
        final donation = donationProvider.donation;
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
          child: SingleChildScrollView(
            child: donation != null
                ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 80), // Space for the app bar
                // Display the image from the URL
                Container(
                  height: 200, // Adjust the height as needed
                  width: double.infinity,
                  child: CachedNetworkImage(
                    imageUrl: donation.url,
                    placeholder: (context, url) => CircularProgressIndicator(),
                    errorWidget: (context, url, error) => Icon(Icons.error),
                    fit: BoxFit.cover,
                  ),
                ),
                SizedBox(height: 20), // Add spacing between image and other details
                Text(
                  'Donation ID: ${donation.id}',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                ListTile(
                  title: Text(
                    'Recipient',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  subtitle: FutureBuilder<String?>(
                    future: userProvider.getUsernameByUid(donation.recipientId!),
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
                ),
                ListTile(
                  title: Text(
                    'Donor',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  subtitle: FutureBuilder<String?>(
                    future: userProvider.getUsernameByUid(donation.donorId!),
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
                ),
                ListTile(
                  title: Text(
                    'Status',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(donation.status ?? 'No Status'),
                ),
                ListTile(
                  title: Text(
                    'Weight',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text('${donation.weight} KG'),
                ),
                ListTile(
                  title: Text(
                    'Donated Items',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text('${donation.donatedItems.join(', ')}'),
                ),
                if (donation.isPickup && donation.status != 'Completed') ...[
                  SizedBox(height: 10),
                  generateQrCode(donation.id),
                ListTile(
                  title: Text(
                    'Contact Number',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(donation.contactNumber),
                ),
                                ListTile(
                  title: Text(
                    'Addresses',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text('${donation.addressForPickup.join(', ')}'),
                ),
                ],
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
    return GestureDetector(
      child: ElevatedButton(
        onPressed: () async {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => QRCodePage(qrData: donationId),
            ),
          );
        },
        child: Text('Generate QR Code'),
      ),
    );
  }
}
