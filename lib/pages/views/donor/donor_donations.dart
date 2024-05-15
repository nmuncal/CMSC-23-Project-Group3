import 'package:flutter/material.dart';
import 'donation_detail.dart';

class DonorDonations extends StatefulWidget {
  const DonorDonations({super.key});

  @override
  State<DonorDonations> createState() => _DonorDonationsState();
}

class _DonorDonationsState extends State<DonorDonations> {
  final List<String> donations = [
    'Donation 1',
    'Donation 2',
    'Donation 3',
    'Donation 4',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Donor Donations'),
        automaticallyImplyLeading: false, 
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