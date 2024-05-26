// ignore_for_file: must_be_immutable

import 'package:cmsc_23_project_group3/models/user_model.dart';
import 'package:cmsc_23_project_group3/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:cmsc_23_project_group3/styles.dart';
import 'package:provider/provider.dart';

class DonorDetails extends StatefulWidget {
  late String? uid;
  DonorDetails({super.key, required this.uid});

  @override
  State<DonorDetails> createState() => _DonorDetailsState();
}

class _DonorDetailsState extends State<DonorDetails> {

  AppUser? donor;
  
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
    donor = context.watch<UserProvider>().selectedUser;

    return donor == null
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
                    donor!.accountType == 2 ? 
                    Container() :
                    donationsSection(),
                  ],
                ),
              ),
            ],
          ),
        );
  }

  donationsSection() {
    return Column(
      children: [
      Text("Donations", style: TextStyle(color: Styles.mainBlue)),
      const SizedBox(height: 10),
      ],
    );
  }

  Widget aboutSection(){
    return Column(children: [
      Text(donor!.name, 
        style: TextStyle(
          color: Styles.mainBlue, 
          fontSize: 24, 
          fontWeight: FontWeight.bold
        )
      ),
    
      Text(
        "@${donor!.username}",
        textAlign: TextAlign.center,
        style: TextStyle(
          color: Styles.darkerGray, 
          fontSize: 14,
        ),
      ),

  
      const SizedBox(height: 10),
    
      Text(
        donor!.desc != "" ? 
        donor!.desc : 
        (donor!.accountType == 2 ? "This user is an admin." : "It's empty here!"),
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
          child: Image.network(
            donor!.coverPhoto != '' ?
            donor!.coverPhoto:
            Styles.defaultCover, // Profile cover image
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
              child: Image.network(
                donor!.profilePhoto != '' ?
                donor!.profilePhoto:
                Styles.defaultProfile
                , // Circular image
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),


      ],
    );
  }
}