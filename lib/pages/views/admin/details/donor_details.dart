import 'package:cmsc_23_project_group3/models/user_model.dart';
import 'package:cmsc_23_project_group3/pages/views/donor/details/donor_details.dart';
import 'package:cmsc_23_project_group3/providers/user_provider.dart';
import 'package:cmsc_23_project_group3/styles.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DonorDetailPage extends StatefulWidget {
  final String donorId;

  const DonorDetailPage({super.key, required this.donorId});

  @override
  State<DonorDetailPage> createState() => _DonorDetailPageState();
}

class _DonorDetailPageState extends State<DonorDetailPage> {
   
  late AppUser? donor;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<UserProvider>().getAccountInfo(null);
      context.read<UserProvider>().getAccountInfo(widget.donorId);
    });
  }

  @override
  Widget build(BuildContext context) {

    donor = context.watch<UserProvider>().selectedUser;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          color: Styles.mainBlue,
          onPressed: () {
            context.read<UserProvider>().getAccountInfo(null);
            Navigator.of(context).pop();
          },
        ), 
        backgroundColor: Colors.transparent,
        centerTitle: true,
      ),
      body: donor == null ? const Center(child: CircularProgressIndicator()) : DonorDetails(uid: widget.donorId),
    );
  }
}
