import 'package:cmsc_23_project_group3/models/donation_model.dart';
import 'package:cmsc_23_project_group3/pages/views/donor/donation_detail.dart';
import 'package:cmsc_23_project_group3/providers/auth_provider.dart';
import 'package:cmsc_23_project_group3/providers/donation_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


class DonorDonations extends StatefulWidget {
  const DonorDonations({super.key});

  @override
  State<DonorDonations> createState() => _DonorDonationsState();
}

class _DonorDonationsState extends State<DonorDonations> {
   @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
       final user = context.read<UserAuthProvider>().user;
      if (user != null) {
        Provider.of<DonationProvider>(context, listen: false).fetchDonationsGiven(user.uid);
        print(user.uid);
      }
   
    });
  }


  Widget build(BuildContext context) {

    return Scaffold(
      appBar: _buildAppBar(context),
      body: Consumer<DonationProvider>(
        builder: (context, donationProvider, child) {
          return StreamBuilder<List<Donation>>(
            stream: donationProvider.donationStream,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Center(child: Text('No donations found'));
              } else {
                final donations = snapshot.data!;
                return ListView.builder(
                  itemCount: donations.length,
                  itemBuilder: (context, index) {
                    final donation = donations[index];
                    return ListTile(
                      title: Text("donation"), 
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => DonationDetailPage(donationName: donation.recipientId,),
                          ),
                        );
                      },
                    );
                  },
                );
              }
            },
          );
        },
      ),
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      title: const Text('Donor Home'),
      automaticallyImplyLeading: false, // This removes the back button
    );
  }
}