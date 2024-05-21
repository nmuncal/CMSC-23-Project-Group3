// ignore_for_file: must_be_immutable

import 'package:cmsc_23_project_group3/models/user_model.dart';
import 'package:cmsc_23_project_group3/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:cmsc_23_project_group3/styles.dart';
import 'package:provider/provider.dart';

class OrganizationDetails extends StatefulWidget {
  late String? uid;
  OrganizationDetails({super.key, required this.uid});

  @override
  State<OrganizationDetails> createState() => _OrganizationDetailsState();
}

class Organization {
  final String name;
  final bool isOpen;
  final String desc;

  Organization({
    required this.name,
    required this.isOpen,
    required this.desc,
  });
}


class _OrganizationDetailsState extends State<OrganizationDetails> {

  AppUser? organization;
  
  final icon = 'lib/assets/ico_app.png';
  final cover = 'lib/assets/ico_splash.png';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<UserProvider>().getAccountInfo(widget.uid!);
    });
  }

  @override
  Widget build(BuildContext context) {
    organization = context.watch<UserProvider>().selectedUser;

    return organization == null
      ? const Center(child: CircularProgressIndicator())
      : SingleChildScrollView(
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
                    drivesSection(),
                  ],
                ),
              ),
            ],
          ),
        );
  }

  drivesSection() {
    return Column(
      children: [
      Text("Active Donation Drives", style: TextStyle(color: Styles.mainBlue)),
      const SizedBox(height: 10),
      Text("Previous Donation Drives", style: TextStyle(color: Styles.mainBlue)),
    
      ],
    );
  }

  Widget aboutSection(){
    return Column(children: [
      Text(organization!.name, 
        style: TextStyle(
          color: Styles.mainBlue, 
          fontSize: 24, 
          fontWeight: FontWeight.bold
        )
      ),
    
      organization!.isOpen ? 
      const Text("Open for Donations", style: TextStyle(color: Colors.green, fontSize: 14)) : 
      const Text("Not Accepting Donations", style: TextStyle(color: Colors.red, fontSize: 14)),
    
      const SizedBox(height: 10),
    
      Text(
        organization!.desc != "" ? organization!.desc : "It's empty here!",
        textAlign: TextAlign.center,
        style: TextStyle(
          color: Styles.darkerGray, 
          fontSize: 14,
        ),
      ),
    ]);
  }

  Widget imageSection(){
   return Stack(
      children: [
        const SizedBox(
          height: 225,
          width: double.infinity,
        ),
        SizedBox(
          height: 200,
          width: double.infinity,
          child: Image.asset(
            cover, // Profile cover image
            fit: BoxFit.cover,
          ),
        ),
        Positioned(
          bottom: 0, // Adjust the position to place it lower than the cover
          left: (MediaQuery.of(context).size.width / 2) - 75, // Center the circle
          child: Container(
            width: 150, // Increase the width to prevent cropping
            height: 150, // Increase the height to prevent cropping
            padding: const EdgeInsets.all(5),
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            child: ClipOval(
              child: Image.asset(
                icon, // Circular image
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),


      ],
    );
  }
}