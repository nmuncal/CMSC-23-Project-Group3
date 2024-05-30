import 'package:cmsc_23_project_group3/models/donation_model.dart';
import 'package:cmsc_23_project_group3/pages/views/donor/donation_detail.dart';
import 'package:cmsc_23_project_group3/providers/auth_provider.dart';
import 'package:cmsc_23_project_group3/providers/donation_provider.dart';
import 'package:cmsc_23_project_group3/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cmsc_23_project_group3/styles.dart';

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
      context.read<UserProvider>().getAccountInfo(null);
      final user = context.read<UserAuthProvider>().user;
      if (user != null) {
        Provider.of<DonationProvider>(context, listen: false).fetchDonationsGiven(user.uid);
      }
    });
  }

  @override
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
                return Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          Text(
                            '${donations.length}',
                            style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            'TOTAL DONATIONS',
                            style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: ListView.builder(
                        itemCount: donations.length,
                        itemBuilder: (context, index) {
                          final donation = donations[index];
                          return FutureBuilder<String?>(
                            future: context.read<UserProvider>().getUsernameByUid(donation.recipientId!),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState == ConnectionState.waiting) {
                                return ListTile(
                                  title: Text('Loading...'),
                                  subtitle: Text(donation.status ?? 'No Status'),
                                );
                              } else if (snapshot.hasError) {
                                return ListTile(
                                  title: Text('Error loading username'),
                                  subtitle: Text(donation.status ?? 'No Status'),
                                );
                              } else {
                                final username = snapshot.data ?? 'UNKNOWN';
                                final pickUpOrDropOff = donation.isPickup ? 'Pick up' : 'Drop off';
                                return Card(
                                  margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                                  elevation: 2,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: ListTile(
                                    contentPadding: const EdgeInsets.all(16),
                                    leading: Icon(Icons.favorite, color: Theme.of(context).primaryColor),
                                    title: Text(
                                      '$username ($pickUpOrDropOff)'.toUpperCase(),
                                      style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                                    ),
                                    subtitle: Text(
                                      donation.status ?? 'No Status',
                                      style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                                    ),
                                    trailing: Icon(Icons.arrow_forward_ios, size: 16),
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => DonationDetailPage(donation: donation),
                                        ),
                                      );
                                    },
                                  ),
                                );
                              }
                            },
                          );
                        },
                      ),
                    ),
                  ],
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
      title: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'My Donations',
          style: TextStyle(
            color: Styles.mainBlue,
            fontWeight: FontWeight.bold,
            fontSize: 30,
          ),
        ),
      ],
    ),
        automaticallyImplyLeading: false,
    );
  }
}
