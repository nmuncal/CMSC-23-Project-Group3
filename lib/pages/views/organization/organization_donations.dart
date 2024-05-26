import 'package:cmsc_23_project_group3/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'details/donations_received_details.dart';

class OrganizationDonations extends StatefulWidget {
  const OrganizationDonations({super.key});

  @override
  State<OrganizationDonations> createState() => _OrganizationDonationsState();
}

class _OrganizationDonationsState extends State<OrganizationDonations> {
  // Define a list of organization donations
  final List<String> donations = [
    'Donor A',
    'Donor B',
    'Donor C',
    'Donor D'
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<UserProvider>().getAccountInfo(null);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Organization Donations'),
      ),
      body: ListView.builder(
        itemCount: donations.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(donations[index]),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DonationDetailPage(donationName: donations[index]),
                ),
              );
            },
          );
        },
      ),
    );
  }
}