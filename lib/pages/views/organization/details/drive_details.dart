import 'package:cmsc_23_project_group3/models/donationDrive_model.dart';
import 'package:cmsc_23_project_group3/providers/donationdrive_provider.dart';
import 'package:flutter/material.dart';
import 'package:cmsc_23_project_group3/styles.dart';
import 'package:provider/provider.dart';

class DriveDetailPage extends StatefulWidget {
  final String driveId;
  final bool? isOrg;
  

  const DriveDetailPage({super.key, required this.driveId, this.isOrg});

  @override
  State<DriveDetailPage> createState() => _DriveDetailsState();
}

class _DriveDetailsState extends State<DriveDetailPage> {

  
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      context.read<DonationDriveProvider>().setDonationDriveId(widget.driveId);
    });
  }

  @override
  Widget build(BuildContext context) {

    DonationDrive? drive = context.read<DonationDriveProvider>().drive;


    return Scaffold(
      appBar: AppBar(
        title: Text(drive!.name),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            imageSection(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Column(
                children: [
                  aboutSection(),
                  const SizedBox(height: 15),
                  const SizedBox(height: 15),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: PopupMenuButton(
        itemBuilder: (context) => [
          const PopupMenuItem(
            value: 'edit',
            child: Text("Edit Drive"),
          ),
          const PopupMenuItem(
            value: 'delete',
            child: Text("Delete Drive", style: TextStyle(color: Colors.red)),
          ),
        ],
        offset: const Offset(0, -100),
        color: Colors.white,
        child: CircleAvatar(
          radius: 30,
          backgroundColor: Styles.mainBlue,
          child: const Icon(
            Icons.more_vert,
            color: Colors.white,
          ),
        ),
        onSelected: (value) {
          if (value == 'edit') {
            _editDrive(context);
          }
          if (value == 'delete') {
            _deleteDrive(context);
          }
        },
      ),
    );
  }

  void _editDrive(BuildContext context) {
    // Implement edit drive functionality
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Edit drive functionality not implemented')),
    );
  }

  void _deleteDrive(BuildContext context) {
    // Implement delete drive functionality
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Delete drive functionality not implemented')),
    );
  }

  Widget aboutSection() {
    DonationDrive? drive = context.read<DonationDriveProvider>().drive;

    return Column(children: [
      Text(drive!.name,
          style: TextStyle(
              color: Styles.mainBlue,
              fontSize: 24,
              fontWeight: FontWeight.bold)),
      drive!.status == true
          ? const Text("Open for Donations",
              style: TextStyle(color: Colors.green, fontSize: 14))
          : const Text("Not Accepting Donations",
              style: TextStyle(color: Colors.red, fontSize: 14)),
      const SizedBox(height: 10),
      Text(
        drive!.details != "" ? drive!.details : "It's empty here!",
        textAlign: TextAlign.center,
        style: TextStyle(
          color: Styles.darkerGray,
          fontSize: 14,
        ),
      ),
    ]);
  }

  Widget imageSection() {
        DonationDrive? drive = context.read<DonationDriveProvider>().drive;

    return Stack(
      children: [
        const SizedBox(
          height: 225,
          width: double.infinity,
        ),
        SizedBox(
          height: 200,
          width: double.infinity,
          child: Image.network(
            drive!.photo != ''
                ? drive!.photo
                : Styles.defaultCover, // Profile cover image
            fit: BoxFit.cover,
          ),
        ),
      ],
    );
  }
}
