import 'package:flutter/material.dart';

class OrganizationProfile extends StatefulWidget {
  const OrganizationProfile({super.key});

  @override
  State<OrganizationProfile> createState() => _OrganizationProfileState();
}

class _OrganizationProfileState extends State<OrganizationProfile> {
  @override
  Widget build(BuildContext context) {
    return const Center(child:Text("Organization Profile"));
  }
}