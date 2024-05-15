import 'package:flutter/material.dart';
import 'details/org_details.dart';

class AdminOrganizations extends StatefulWidget {
  const AdminOrganizations({super.key});

  @override
  State<AdminOrganizations> createState() => _AdminOrganizationsState();
}

class _AdminOrganizationsState extends State<AdminOrganizations> {
  // Define a list of organizations
  final List<String> organizations = [
    'Organization A',
    'Organization B',
    'Organization C',
    'Organization D',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Organizations'),
      ),
      body: ListView.builder(
        itemCount: organizations.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(organizations[index]),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => OrganizationDetailPage(organizationName: organizations[index]),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

