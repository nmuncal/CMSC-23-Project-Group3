import 'package:cmsc_23_project_group3/pages/views/admin/admin_donors.dart';
import 'package:cmsc_23_project_group3/pages/views/admin/admin_organizations.dart';
import 'package:cmsc_23_project_group3/pages/views/admin/admin_pending.dart';
import 'package:cmsc_23_project_group3/pages/views/admin/admin_profile.dart';

import 'package:cmsc_23_project_group3/styles.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

class AdminView extends StatefulWidget {
  const AdminView({super.key});

  @override
  State<AdminView> createState() => _AdminViewState();
}

class _AdminViewState extends State<AdminView> {
  int _currPageIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              blurRadius: 10,
              color: Colors.grey.withOpacity(0.3),
            ),
          ],
        ),
        child: GNav(
          haptic: true,
          tabBorderRadius: 50,
          gap: 5,
          color: Styles.darkerGray,
          activeColor: Styles.mainBlue,
          backgroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          onTabChange: (index) {
            setState(() {
              _currPageIndex = index;
              print(index);
            });
          },
          tabs: const [
            GButton(
              icon: Icons.groups_outlined,
              text: 'Organizations'
            ),
            GButton(
              icon: Icons.group_add_outlined,
              text: 'Sign Ups'
            ),
            GButton(
              icon: Icons.person_pin_rounded,
              text: 'Donors'
            ),
            GButton(
              icon: Icons.person_outline_rounded,
              text: 'My Profile'
            ),
          ]
        ),
      ),
      body: pageHandler()
    );
  }

  Widget pageHandler(){
    if (_currPageIndex == 0) return AdminOrganizations();
    else if (_currPageIndex == 1) return AdminPending();
    else if (_currPageIndex == 2) return AdminDonors();
    return AdminProfile();
  }
}