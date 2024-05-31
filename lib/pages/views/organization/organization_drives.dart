import 'package:cmsc_23_project_group3/models/donationDrive_model.dart';
import 'package:cmsc_23_project_group3/pages/views/organization/details/drive_details.dart';
import 'package:cmsc_23_project_group3/providers/auth_provider.dart';
import 'package:cmsc_23_project_group3/providers/donationdrive_provider.dart';
import 'package:cmsc_23_project_group3/providers/user_provider.dart';
import 'package:cmsc_23_project_group3/styles.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class OrganizationDrives extends StatefulWidget {
  const OrganizationDrives({super.key});

  @override
  State<OrganizationDrives> createState() => _OrganizationDrivesState();
}

class _OrganizationDrivesState extends State<OrganizationDrives> {

  final ScrollController _scrollController = ScrollController(); 

   @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<UserProvider>().getAccountInfo(null);
      final user = context.read<UserAuthProvider>().user;
      if (user != null) {
        Provider.of<DonationDriveProvider>(context, listen: false).fetchDrives(user.uid);
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  User? user;

  Widget build(BuildContext context) {

    user = context.read<UserAuthProvider>().user;

    return Scaffold(
      appBar: _buildAppBar(context),
      body: Consumer<DonationDriveProvider>(
        builder: (context, driveProvider, child) {
          return StreamBuilder<List<DonationDrive>>(
            stream: driveProvider.driveStream,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Center(child: Text('No drives found'));
              } else {
                final drives = snapshot.data!;
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                  child: ListView.builder(
                    controller: _scrollController,
                    itemCount: drives.length,
                    itemBuilder: (context, index) {
                      final drive = drives[index];
                      return componentTiles(drive, index);
                    },
                  ),
                );
              }
            },
          );
        },
      ),
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
          SizedBox(width: 10),
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
        builder: (context) => DriveDetailPage(driveId: drive.id, isOrg: true),
      ),
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      title: Center(
        child: Text(
          'tayo',
          style: GoogleFonts.quicksand(
            color: Styles.mainBlue,
            fontWeight: FontWeight.bold,
            fontSize: 30
          ),
        ),
      ),
      automaticallyImplyLeading: false,
    );
  }

}
