import 'package:flutter/material.dart';
import 'details/donor_details.dart';

class AdminDonors extends StatefulWidget {
  const AdminDonors({super.key});

  @override
  State<AdminDonors> createState() => _AdminDonorsState();
}

class _AdminDonorsState extends State<AdminDonors> {
  // Define a list of donors
  final List<String> donors = [
    'Donor A',
    'Donor B',
    'Donor C',
    'Donor D',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Donors'),
      ),
      body: ListView.builder(
        itemCount: donors.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(donors[index]),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DonorDetailPage(donorName: donors[index]),
                ),
              );
            },
          );
        },
      ),
    );
  }
}


