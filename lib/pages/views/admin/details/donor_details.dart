import 'package:flutter/material.dart';

class DonorDetailPage extends StatelessWidget {
  final String donorName;

  const DonorDetailPage({super.key, required this.donorName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(donorName),
      ),
      body: Center(
        child: Text('Details about $donorName'),
      ),
    );
  }
}
