// NOTHING TO EDIT HERE
// Routes the donor's view to different pages

import 'package:cmsc_23_project_group3/pages/views/donor/donor_donations.dart';
import 'package:cmsc_23_project_group3/pages/views/donor/donor_home.dart';
import 'package:cmsc_23_project_group3/pages/views/donor/donor_profile.dart';

import 'package:cmsc_23_project_group3/styles.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

class DonorView extends StatefulWidget {
  const DonorView({super.key});

  @override
  State<DonorView> createState() => _DonorViewState();
}

class _DonorViewState extends State<DonorView> {
  int _currPageIndex = 0;
  var _pages = [DonorHome(), DonorDonations(), DonorProfile()];
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
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
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
              icon: Icons.home_outlined,
              text: 'Home'
            ),
            GButton(
              icon: Icons.healing_outlined,
              text: 'My Donations'
            ),
            GButton(
              icon: Icons.person_outline_rounded,
              text: 'My Profile'
            ),
          ]
        ),
      ),
      body: PageView(
        children: _pages,
        controller: _pageController,
        onPageChanged: (index){
          setState(() {
            _currPageIndex = index;
          });
        },
      )
    );
  }
}