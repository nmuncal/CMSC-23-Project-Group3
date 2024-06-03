import 'package:cmsc_23_project_group3/models/donationDrive_model.dart';
import 'package:cmsc_23_project_group3/pages/views/organization/details/contact_details.dart';
import 'package:cmsc_23_project_group3/pages/views/organization/details/drive_details.dart';
import 'package:flutter/material.dart';
import 'package:cmsc_23_project_group3/models/user_model.dart';
import 'package:cmsc_23_project_group3/providers/user_provider.dart';
import 'package:cmsc_23_project_group3/styles.dart';
import 'package:provider/provider.dart';
import '../../../../providers/donationdrive_provider.dart';

class OrganizationDetails extends StatefulWidget {
  late String? uid;
  OrganizationDetails({super.key, required this.uid});

  @override
  State<OrganizationDetails> createState() => _OrganizationDetailsState();
}

class _OrganizationDetailsState extends State<OrganizationDetails> {
  AppUser? organization;
  bool isContactSectionVisible = false;

  final ScrollController _scrollController = ScrollController(); 

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<UserProvider>().getAccountInfo(widget.uid!);
      Provider.of<DonationDriveProvider>(context, listen: false).fetchDrives(widget.uid!);
    });

     _activeDrivesPageController.addListener(() {
      setState(() {
        _activeDrivesPageIndex = _activeDrivesPageController.page!;
      });
    });

    _previousDrivesPageController.addListener(() {
      setState(() {
        _previousDrivesPageIndex = _previousDrivesPageController.page!;
      });
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
                Column(
                  children: [
                    aboutSection(),
                    const SizedBox(height: 15),
                    IconButton(
                      onPressed: () {
                        setState(() {
                          isContactSectionVisible = !isContactSectionVisible;
                        });
                      },
                      icon: Icon(isContactSectionVisible ? Icons.visibility_off_outlined : Icons.perm_contact_cal_rounded),
                      tooltip: isContactSectionVisible ? 'Hide Contact Section' : 'Show Contact Section',
                    ),
                    Visibility(
                      visible: isContactSectionVisible,
                      child: Center(
                        child: ContactDetails(user: organization),
                      ),
                    ),
                    const SizedBox(height: 15),
                    drivesSection()
                  ],
                ),
              ],
            ),
          );
  }

  final PageController _activeDrivesPageController = PageController(viewportFraction: 0.8);
  final PageController _previousDrivesPageController = PageController(viewportFraction: 0.8);
  double _activeDrivesPageIndex = 0;
  double _previousDrivesPageIndex = 0;

  Widget drivesSection() {
  return Consumer<DonationDriveProvider>(
    builder: (context, driveProvider, child) {
      return StreamBuilder<List<DonationDrive>>(
        stream: driveProvider.driveStreamCopy,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No drives found'));
          } else {
            final drives = snapshot.data!;
            final activeDrives =
                drives.where((drive) => drive.status).toList();
            
            final previousDrives =
                drives.where((drive) => !drive.status).toList();

            return Column(
              children: [
                Text(
                  "Active Donation Drives",
                  style: TextStyle(color: Styles.mainBlue),
                ),
                activeDrives.isEmpty ?
                Text("No Active Drives", style: TextStyle(color: Styles.darkerGray),):
                Container(
                  height: 200,
                  margin: EdgeInsets.symmetric(vertical: 10),
                  child: PageView.builder(
                        controller: _activeDrivesPageController,
                        itemCount: activeDrives.length,
                        itemBuilder: (context, index) {
                          final activeDrive = activeDrives[index];
                          return componentTiles(activeDrive, index);
                        },
                      ),
                  ),
                
                SizedBox(height: 20),
                Text(
                  "Previous Donation Drives",
                  style: TextStyle(color: Styles.mainBlue),
                ),
                previousDrives.isEmpty ?
                Text("No Previous Drives", style: TextStyle(color: Styles.darkerGray),):
                Container(
                  height: 200,
                  margin: EdgeInsets.symmetric(vertical: 10),
                    child: PageView.builder(
                        controller: _activeDrivesPageController,
                        itemCount: previousDrives.length,
                        itemBuilder: (context, index) {
                        final previousDrive = previousDrives[index];
                        return componentTiles(
                              previousDrive, index + activeDrives.length);
                      },
                      ),
                    
                  ),
                ]);
          }
        },
      );
    },
  );
}


  
Widget componentTiles(DonationDrive drive, int index) {
  return GestureDetector(
    onTap: () => {_navigateToDrive(context, drive)},
    child: Card(
        elevation: 2,
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: Styles.rounded,
        ),
        child: ClipRRect(
          borderRadius: Styles.rounded,
          child: Stack(
            children: [
              _buildCoverImage(drive, index),
              _buildGradientOverlay(context, drive),
            ],
          ),
        ),
      ),
    );
  }

Widget _buildCoverImage(DonationDrive drive, int index) {
  return AnimatedBuilder(
    animation: _scrollController,
    builder: (context, child) {
      double maxOffset = 75.0;
      double offset = _scrollController.hasClients ? _scrollController.offset / 4 : 0;
      offset = offset - (index * 20);
      offset = offset.clamp(0, maxOffset);

      return Transform.translate(
        offset: Offset(0.0, offset * 0.5),
        child: Transform.scale(
          scale: 1.4,
          child: Stack(
            children: [
              Image.network(
                drive.photo != '' ? drive.photo : Styles.defaultCover,
                height: 200,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
              Container(
                height: 200,
                width: double.infinity,
                color: Colors.black.withOpacity(0.3), // Adjust opacity as needed
              ),
            ],
          ),
        ),
      );
    },
  );
}



  Widget _buildGradientOverlay(BuildContext context, drive) {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
          padding: const EdgeInsets.all(10),
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color.fromARGB(203, 0, 0, 0), Colors.black38, Color.fromARGB(115, 0, 0, 0), Colors.transparent],
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
            ),
          ),
          child: _buildTextContent(drive),
        ),
      );
  }

Widget _buildTextContent(DonationDrive drive) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Row(
        children: [
          Text(
            drive.name,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(width: 10),
          Container(
            width: 10,
            height: 10,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: drive.status == true ? Colors.green : Colors.red,
            ),
          ),
        ],
      ),
      const SizedBox(height: 5),
      Text(
        drive.details.isNotEmpty ? drive.details : "This drive is still crafting its story!",
        style: const TextStyle(color: Colors.white70),
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      ),
    ],
  );
}


  void _navigateToDrive(BuildContext context, DonationDrive drive) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DriveDetailPage(driveId: drive.id),
      ),
    );
  }

  Widget aboutSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: Column(children: [
        Text(organization!.name,
            style: TextStyle(
                color: Styles.mainBlue,
                fontSize: 24,
                fontWeight: FontWeight.bold)),
        organization!.isOpen
            ? const Text("Open for Donations",
                style: TextStyle(color: Colors.green, fontSize: 14))
            : const Text("Not Accepting Donations",
                style: TextStyle(color: Colors.red, fontSize: 14)),
        const SizedBox(height: 10),
        Text(
          organization!.desc != "" ? organization!.desc : "It's empty here!",
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Styles.darkerGray,
            fontSize: 14,
          ),
        ),
      ]),
    );
  }

  Widget imageSection() {
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
            organization!.coverPhoto != ''
                ? organization!.coverPhoto
                : Styles.defaultCover, // Profile cover image
            fit: BoxFit.cover,
          ),
        ),
        Positioned(
          bottom: 0, // Adjust the position to place it lower than the cover
          left: (MediaQuery.of(context).size.width / 2) -
              75, // Center the circle
          child: Container(
            width:
                150, // Increase the width to prevent cropping
            height:
                150, // Increase the height to prevent cropping
            padding: const EdgeInsets.all(5),
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            child: ClipOval(
              child: Image.network(
                organization!.profilePhoto != ''
                    ? organization!.profilePhoto
                    : Styles.defaultProfile, // Circular image
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
      ],
    );
  }

  
}
