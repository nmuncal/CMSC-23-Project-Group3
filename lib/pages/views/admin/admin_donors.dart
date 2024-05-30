import 'package:cmsc_23_project_group3/providers/user_provider.dart';
import 'package:cmsc_23_project_group3/styles.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../providers/donation_provider.dart';
import '/models/user_model.dart';
import 'details/donor_details.dart';

class AdminDonors extends StatefulWidget {
  const AdminDonors({super.key});

  @override
  State<AdminDonors> createState() => _DonorHomeState();
}

class _DonorHomeState extends State<AdminDonors> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      context.read<DonationProvider>().fetchDonationsGiven(null);
      await context.read<UserProvider>().getAccountInfo(null);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      body: Consumer<UserProvider>(
        builder: (context, userProvider, child) {
          return StreamBuilder<List<AppUser>>(
            stream: userProvider.donorStream,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Center(child: Text('No donors found'));
              } else {
                final donors = snapshot.data!;
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: ListView.builder(
                    itemCount: donors.length,
                    itemBuilder: (context, index) {
                      final donor = donors[index];
                      return componentTiles(donor);
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

  Widget componentTiles(AppUser user) {
    return ListTile(
      contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
      leading: Stack(
        children: [
          CircleAvatar(
            backgroundImage: NetworkImage(
              user.profilePhoto != '' ?
              user.profilePhoto :
              Styles.defaultProfile
            ),
            backgroundColor: Colors.transparent,
            radius: 30.0, 
          ),

          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: Styles.mainBlue,
                  width: 1.5,
                ),
                shape: BoxShape.circle,
              ),
            ),
          ),
        ],
      ),
      title: Text("@${user.username}"),
      trailing: Icon(Icons.navigate_next_rounded, color: Styles.darkerGray),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DonorDetailPage(donorId: user.uid),
          ),
        );
      },
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      title: const Text('Donors'),
      automaticallyImplyLeading: false, // This removes the back button
    );
  }
}