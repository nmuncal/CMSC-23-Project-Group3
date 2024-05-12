import 'package:flutter/material.dart';

class AdminDonors extends StatefulWidget {
  const AdminDonors({super.key});

  @override
  State<AdminDonors> createState() => _AdminDonorsState();
}

class _AdminDonorsState extends State<AdminDonors> {
  @override
  Widget build(BuildContext context) {
    return const Center(child:Text("Donors"));
  }
}