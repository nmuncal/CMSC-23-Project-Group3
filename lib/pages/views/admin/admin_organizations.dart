import 'package:cmsc_23_project_group3/pages/views/admin/details/org_details.dart';
import 'package:cmsc_23_project_group3/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '/models/user_model.dart';
import 'details/donor_details.dart';

class AdminOrganizations extends StatefulWidget {
  const AdminOrganizations({super.key});

  @override
  State<AdminOrganizations> createState() => _DonorHomeState();
}

class _DonorHomeState extends State<AdminOrganizations> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<UserProvider>(context, listen: false).fetchOrganizations();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      body: Consumer<UserProvider>(
        builder: (context, userProvider, child) {
          return StreamBuilder<List<AppUser>>(
            stream: userProvider.uStream,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Center(child: Text('No donors found'));
              } else {
                final donors = snapshot.data!;
                return ListView.builder(
                  itemCount: donors.length,
                  itemBuilder: (context, index) {
                    final donor = donors[index];
                    return ListTile(
                      title: Text(donor.name),
                                            onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => OrganizationDetailPage(organizationName: donor.name),
                          ),
                        );
                      },
                       // Assuming `AppUser` has a `name` field
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
      title: const Text('Organizations'),
      automaticallyImplyLeading: false, // This removes the back button
    );
  }
}