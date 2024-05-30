import 'package:cmsc_23_project_group3/pages/views/organization/details/edit_organization.dart';
import 'package:cmsc_23_project_group3/providers/donation_provider.dart';
import 'package:cmsc_23_project_group3/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'details/donor_details.dart';

import 'package:cmsc_23_project_group3/styles.dart';

import 'package:cmsc_23_project_group3/providers/auth_provider.dart';
import 'package:provider/provider.dart';

class DonorProfile extends StatefulWidget {
  const DonorProfile({super.key});

  @override
  State<DonorProfile> createState() => _DonorProfileState();
}

class _DonorProfileState extends State<DonorProfile> {
  String? userId;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<UserProvider>().getAccountInfo(null);
    });
  }

  @override
  Widget build(BuildContext context) {
    
    userId = context.watch<UserAuthProvider>().user!.uid;

    return Scaffold(
      body: DonorDetails(uid: userId),
      floatingActionButton: PopupMenuButton(
        itemBuilder: (context) => [
          const PopupMenuItem(
            value: 'edit',
            child: Text("Edit Profile")
          ),
          const PopupMenuItem(
            value: 'sign out',
            child: Text("Sign Out", style: TextStyle(color: Colors.red),)
          )
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
        onSelected: (value){
          if (value == 'edit'){
            Navigator.push(
              context,
              MaterialPageRoute(
              builder: (context) => EditOrganization(orgId: userId!),
              ),
            );
          }
          if (value == 'sign out'){
            context.read<UserAuthProvider>().signOut();
          }
        },
      )
    );
  }
}