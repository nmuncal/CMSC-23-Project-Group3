import 'package:flutter/material.dart';

class DonationDetailPage extends StatelessWidget {
  final String donationName;

  const DonationDetailPage({super.key, required this.donationName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(donationName),
      ),
      body: Center(
        child: Text('Details about $donationName'),
      ),
    );
  }
}