import 'package:cmsc_23_project_group3/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'details/drive_details.dart';

class OrganizationDrives extends StatefulWidget {
  const OrganizationDrives({super.key});

  @override
  State<OrganizationDrives> createState() => _OrganizationDrivesState();
}

class _OrganizationDrivesState extends State<OrganizationDrives> {
  // Define a list of organization drives
  final List<String> drives = [
    'Drive 1',
    'Drive 2',
    'Drive 3',
    'Drive 4',
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<UserProvider>().getAccountInfo(null);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Organization Drives'),
      ),
      body: ListView.builder(
        itemCount: drives.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(drives[index]),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DriveDetailPage(driveName: drives[index]),
                ),
              );
            },
          );
        },
      ),
    );
  }
}