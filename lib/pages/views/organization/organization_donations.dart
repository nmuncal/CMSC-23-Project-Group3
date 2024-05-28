import 'package:cmsc_23_project_group3/models/donation_model.dart';
import 'package:cmsc_23_project_group3/pages/views/organization/details/donations_received_details.dart';
import 'package:cmsc_23_project_group3/pages/views/organization/qr_scanner.dart';
import 'package:cmsc_23_project_group3/providers/auth_provider.dart';
import 'package:cmsc_23_project_group3/providers/donation_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class OrganizationDonations extends StatefulWidget {
  const OrganizationDonations({super.key});

  @override
  State<OrganizationDonations> createState() => _OrganizationDonationsState();
}

class _OrganizationDonationsState extends State<OrganizationDonations> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      final user = context.read<UserAuthProvider>().user;
      if (user != null) {
        Provider.of<DonationProvider>(context, listen: false)
            .fetchDonationsReceived(user.uid);
        print(user.uid);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      body: Consumer<DonationProvider>(
        builder: (context, donationProvider, child) {
          return StreamBuilder<List<Donation>>(
            stream: donationProvider.donationStream,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Center(child: Text('No donations found'));
              } else {
                final donations = snapshot.data!;
                return ListView.builder(
                  itemCount: donations.length,
                  itemBuilder: (context, index) {
                    final donation = donations[index];
                    return ListTile(
                      title: Text("donation"),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                DonationDetailPage(donation: donation),
                          ),
                        );
                      },
                    );
                  },
                );
              }
            },
          );
        },
      ),
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      title: const Text('Organization Donations'),
      automaticallyImplyLeading: false, // This removes the back button
      actions: [
        IconButton(
          icon: const Icon(Icons.qr_code),
          onPressed: () {
            // Navigate to QR scan page
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const QRCodeScannerPage()),
            );
          },
        ),
      ],
    );
  }
}
