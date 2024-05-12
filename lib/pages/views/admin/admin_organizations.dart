import 'package:flutter/material.dart';

class AdminOrganizations extends StatefulWidget {
  const AdminOrganizations({super.key});

  @override
  State<AdminOrganizations> createState() => _AdminOrganizationsState();
}

class _AdminOrganizationsState extends State<AdminOrganizations> {
  @override
  Widget build(BuildContext context) {
    return const Center(child:Text("Organizations"));
  }
}