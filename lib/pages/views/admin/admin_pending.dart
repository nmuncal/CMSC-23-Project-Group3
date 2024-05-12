import 'package:flutter/material.dart';

class AdminPending extends StatefulWidget {
  const AdminPending({super.key});

  @override
  State<AdminPending> createState() => _AdminPendingState();
}

class _AdminPendingState extends State<AdminPending> {
  @override
  Widget build(BuildContext context) {
    return const Center(child:Text("Pending Signups"));
  }
}