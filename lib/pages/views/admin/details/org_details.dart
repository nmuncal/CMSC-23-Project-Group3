import 'package:flutter/material.dart';

class OrganizationDetailPage extends StatelessWidget {
  final String organizationName;

  const OrganizationDetailPage({super.key, required this.organizationName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(organizationName),
      ),
      body: Center(
        child: Text('Details about $organizationName'),
      ),
    );
  }
}