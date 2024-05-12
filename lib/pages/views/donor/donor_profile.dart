import 'package:flutter/material.dart';

class DonorProfile extends StatefulWidget {
  const DonorProfile({super.key});

  @override
  State<DonorProfile> createState() => _DonorProfileState();
}

class _DonorProfileState extends State<DonorProfile> {
  @override
  Widget build(BuildContext context) {
    return const Center(child:Text("Donor Profile"));
  }
}