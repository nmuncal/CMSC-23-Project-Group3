import 'package:cmsc_23_project_group3/models/donationDrive_model.dart';
import 'package:cmsc_23_project_group3/models/donation_model.dart';
import 'package:cmsc_23_project_group3/pages/views/donor/donation_detail.dart';
import 'package:cmsc_23_project_group3/providers/donation_provider.dart';
import 'package:cmsc_23_project_group3/providers/donationdrive_provider.dart';
import 'package:cmsc_23_project_group3/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:cmsc_23_project_group3/styles.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

<<<<<<< Updated upstream
class DriveDetailPage extends StatefulWidget {
  final String driveId;
  final bool? isOrg;

  const DriveDetailPage({super.key, required this.driveId, this.isOrg});

  @override
  State<DriveDetailPage> createState() => _DriveDetailPageState();
}

class _DriveDetailPageState extends State<DriveDetailPage> {


  // IF isOrg show routing of donations
=======
class DriveDetailsPage extends StatefulWidget {
  final String? id;

  const DriveDetailsPage({Key? key, required this.id}) : super(key: key);

  @override
  State<DriveDetailsPage> createState() => _DriveDetailsState();
}

class _DriveDetailsState extends State<DriveDetailsPage> {
  DonationDrive? drive;

   @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      final driveProvider = context.read<DonationDriveProvider>();
      driveProvider.setDonationDriveId(widget.id!);
      // drive = driveProvider.drive;

      // if (drive != null) {
      //   context.read<DonationProvider>().fetchDonationsbyId(drive!.donations);
      // }
    });
  }
>>>>>>> Stashed changes

  @override
  Widget build(BuildContext context) {

     drive = context.read<DonationDriveProvider>().drive;

      if (drive != null) {
        context.read<DonationProvider>().fetchDonationsbyId(drive!.donations);
      }

    return Scaffold(
      appBar: AppBar(
<<<<<<< Updated upstream
        title: Text(widget.driveId),
      ),
      body: Center(
        child: Text('Details about ${widget.driveId}'),
=======
        title: Text('Drive Details'),
      ),
      body: drive == null
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
                        _buildDonationsSection(),
                        const SizedBox(height: 15),
                      ],
                    ),
                  ),
                ],
              ),
            ),
      floatingActionButton: PopupMenuButton(
        itemBuilder: (context) => [
          const PopupMenuItem(
            value: 'edit',
            child: Text("Edit Drive"),
          ),
          const PopupMenuItem(
            value: 'delete',
            child: Text("Delete Drive", style: TextStyle(color: Colors.red)),
          ),
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
        onSelected: (value) {
          if (value == 'edit') {
            _editDrive(context);
          }
          if (value == 'delete') {
            _deleteDrive(context);
          }
        },
      ),
    );
  }

  void _editDrive(BuildContext context) {
    // Implement edit drive functionality
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Edit drive functionality not implemented')),
    );
  }

  void _deleteDrive(BuildContext context) {
    // Implement delete drive functionality
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Delete drive functionality not implemented')),
    );
  }

  Widget aboutSection() {
    return Column(children: [
      Text(drive!.name,
          style: TextStyle(
              color: Styles.mainBlue,
              fontSize: 24,
              fontWeight: FontWeight.bold)),
      drive!.status == true
          ? const Text("Open for Donations",
              style: TextStyle(color: Colors.green, fontSize: 14))
          : const Text("Not Accepting Donations",
              style: TextStyle(color: Colors.red, fontSize: 14)),
      const SizedBox(height: 10),
      Text(
        drive!.details != "" ? drive!.details : "It's empty here!",
        textAlign: TextAlign.center,
        style: TextStyle(
          color: Styles.darkerGray,
          fontSize: 14,
        ),
      ),
    ]);
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
            drive!.photo != ''
                ? drive!.photo
                : Styles.defaultCover, // Profile cover image
            fit: BoxFit.cover,
          ),
        ),
      ],
    );
  }

  Widget _buildDonationsSection() {
    return Consumer<DonationProvider>(
      builder: (context, donationProvider, child) {
        final donationStream = donationProvider.driveDonationsStream;
        return StreamBuilder<List<Donation>>(
          stream: donationStream,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(
                  child: Text('No donations found',
                      style: TextStyle(color: Styles.darkerGray)));
            } else {
              final donations = snapshot.data!;
              return ListView.builder(
                padding: EdgeInsets.all(0),
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: donations.length,
                itemBuilder: (context, index) {
                  return FutureBuilder<Widget>(
                    future: _buildDonationTile(donations[index]),
                    builder: (context, snapshot) {
                      return snapshot.hasData ? snapshot.data! : Container();
                    },
                  );
                },
              );
            }
          },
        );
      },
    );
  }

  Future<Widget> _buildDonationTile(Donation donation) async {
    final userProvider = context.read<UserProvider>();
    final recipient = await userProvider.fetchInfo(donation.recipientId);
    final donor = await userProvider.fetchInfo(donation.donorId);


    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DonationDetailPage(donation: donation),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 20),
        margin: const EdgeInsets.symmetric(vertical: 8.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: Styles.rounded,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 2,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAvatar(
                  backgroundImage: NetworkImage(  donor!.profilePhoto.isNotEmpty
                          ? donor.profilePhoto
                          : Styles.defaultProfile),
                  radius: 24.0,
                ),
                const SizedBox(width: 16.0),
                _buildStatusIcon(donation.status),
                const SizedBox(width: 16.0),
                CircleAvatar(
                  backgroundImage: NetworkImage(
                      recipient!.profilePhoto.isNotEmpty
                          ? recipient.profilePhoto
                          : Styles.defaultProfile),
                  radius: 24.0,
                ),
              ],
            ),
            const SizedBox(height: 8.0),
            _buildRichText("Donated to ", recipient.name),
            const SizedBox(height: 4.0),
            Text(
              DateFormat('dd MMM, yyyy | HH:mm')
                  .format(donation.selectedDateandTime.toDate()),
              style: TextStyle(
                fontSize: 12.0,
                fontStyle: FontStyle.italic,
                color: Styles.darkerGray,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusIcon(String status) {
    if (status == 'Completed') {
      return const Icon(Icons.check, size: 24.0, color: Colors.green);
    } else if (status == 'Cancelled') {
      return const Icon(Icons.close, size: 24.0, color: Colors.red);
    } else {
      return Icon(Icons.more_horiz_outlined,
          size: 24.0, color: Styles.darkerGray);
    }
  }

  Widget _buildRichText(String prefix, String name) {
    return RichText(
      text: TextSpan(
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.normal,
          color: Styles.mainBlue,
          fontFamily: Theme.of(context).textTheme.bodyLarge!.fontFamily,
        ),
        children: [
          TextSpan(
            text: prefix,
          ),
          TextSpan(
            text: "$name",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontFamily: Theme.of(context).textTheme.bodyLarge!.fontFamily,
            ),
          ),
        ],
>>>>>>> Stashed changes
      ),
    );
  }
}
