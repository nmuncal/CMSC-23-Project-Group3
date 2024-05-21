import 'package:cmsc_23_project_group3/models/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'details/organization_details.dart';

import 'package:cmsc_23_project_group3/styles.dart';

import 'package:cmsc_23_project_group3/providers/auth_provider.dart';
import 'package:provider/provider.dart';

class OrganizationProfile extends StatefulWidget {
  const OrganizationProfile({super.key});

  @override
  State<OrganizationProfile> createState() => _OrganizationProfileState();
}

class _OrganizationProfileState extends State<OrganizationProfile> {
  String? userId;

  @override
  Widget build(BuildContext context) {
    
    userId = context.watch<UserAuthProvider>().user!.uid;

    return Scaffold(
      body: OrganizationDetails(uid: userId),
      floatingActionButton: PopupMenuButton(
        itemBuilder: (context) => [
          const PopupMenuItem(
            value: 'edit',
            child: Text("Edit Profile")
          ),
          const PopupMenuItem(
            value: 'sign out',
            child: Text("Sign Out")
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

          }
          if (value == 'sign out'){
            context.read<UserAuthProvider>().signOut();
          }
        },
      )
    );
  }
}