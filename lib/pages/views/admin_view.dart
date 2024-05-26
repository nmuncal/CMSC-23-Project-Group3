// NOTHING TO EDIT HERE
// Routes the user's view to different pages

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
  var _pages = [AdminOrganizations(), AdminPending(), AdminDonors(), AdminProfile()];
  var _pageController = PageController();

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
          selectedIndex: _currPageIndex,
          onTabChange: (index) {
            setState(() {
              _currPageIndex = index;
              _pageController.animateToPage(_currPageIndex, 
                duration: Duration(milliseconds: 250), 
                curve: Curves.linear);
            });
          },
          tabs: const [
            GButton(
              icon: Icons.groups_outlined,
              text: 'Orgs'
            ),
            GButton(
              icon: Icons.group_add_outlined,
              text: 'Pending'
            ),
            GButton(
              icon: Icons.person_pin_rounded,
              text: 'Donors'
            ),
            GButton(
              icon: Icons.person_outline_rounded,
              text: 'Profile'
            ),
          ]
        ),
      ),
      body: PageView(
        controller: _pageController,
        onPageChanged: (index){
          setState(() {
            _currPageIndex = index;
          });
        },
        children: _pages,
      )
    );
  }
}