import 'package:flutter/material.dart';
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