import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cmsc_23_project_group3/providers/donation_provider.dart';
import 'package:cmsc_23_project_group3/providers/user_provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cmsc_23_project_group3/styles.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cmsc_23_project_group3/models/donation_model.dart';

class DonationDetailPage extends StatefulWidget {
  final Donation? donation;

  const DonationDetailPage({Key? key, this.donation}) : super(key: key);

  @override
  _DonationDetailPageState createState() => _DonationDetailPageState();
}

class _DonationDetailPageState extends State<DonationDetailPage> {
  String? _selectedStatus;

  @override
  void initState() {
    super.initState();
    _selectedStatus = widget.donation?.status;
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      Provider.of<DonationProvider>(context, listen: false)
          .setDonationId(widget.donation!.id);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context, Text(
        'Donation Details',
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
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  GestureDetector(
                    onTap: () {
                      _showStatusOptions(context, donation);
                    },
                    child: SizedBox(
                      width: double.infinity,
                      child: Card(
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Text(
                            _selectedStatus ?? donation.status ?? 'No Status',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
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
                      donation.contactNumber ?? 'N/A',
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
                      donation.addressForPickup.join(', ') ?? 'N/A',
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                    SizedBox(height: 20),
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

void _showStatusOptions(BuildContext context, Donation donation) {
  if (donation.status == 'Cancelled') {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Are you sure?'),
        content: Text('This action cannot be undone. Are you sure you want to mark this donation as Cancelled?'),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Close the dialog
              _markAsCancelled(context, donation);
            },
            child: Text('Yes'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context), // Close the dialog
            child: Text('No'),
          ),
        ],
      ),
    );
    return;
  }

  showModalBottomSheet(
    context: context,
    builder: (context) {
      return Container(
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildStatusOption('Pending', donation),
            _buildStatusOption('Confirmed', donation),
            if (donation.isPickup) _buildStatusOption('Scheduled for Pick-up', donation),
            _buildStatusOption('Cancelled', donation),
            _buildStatusOption('Complete', donation),
          ],
        ),
      );
    },
  );
}

void _markAsCancelled(BuildContext context, Donation donation) {
  // Update donation status
  Provider.of<DonationProvider>(context, listen: false)
      .updateDonationStatus(donation.id, 'Cancelled');
}

Widget _buildStatusOption(String status, Donation donation) {
  return GestureDetector(
    onTap: () {
      if (status == 'Cancelled') {
        _showCancellationConfirmation(context, donation);
      } else {
        setState(() {
          _selectedStatus = status;
          // Update donation status
          Provider.of<DonationProvider>(context, listen: false)
              .updateDonationStatus(donation.id, status);
        });
        Navigator.pop(context); // Close the bottom sheet
      }
    },
    child: Container(
      padding: EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.grey.shade300)),
      ),
      child: Text(
        status,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 16,
          color: _selectedStatus == status ? Theme.of(context).primaryColor : null,
          fontWeight: _selectedStatus == status ? FontWeight.bold : null,
        ),
      ),
    ),
  );
}

void _showCancellationConfirmation(BuildContext context, Donation donation) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text('Are you sure?'),
      content: Text('This action cannot be undone. Are you sure you want to mark this donation as Cancelled?'),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.pop(context); // Close the dialog
            _markAsCancelled(context, donation);
          },
          child: Text('Yes'),
        ),
        TextButton(
          onPressed: () => Navigator.pop(context), // Close the dialog
          child: Text('No'),
        ),
      ],
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