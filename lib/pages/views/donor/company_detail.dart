import 'package:flutter/material.dart';

class CompanyDetailPage extends StatelessWidget {
  final String companyName;

  const CompanyDetailPage({super.key, required this.companyName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(companyName),
      ),
      body: Center(
        child: Text('Details about $companyName'),
      ),
    );
  }
}