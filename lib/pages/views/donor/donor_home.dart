import 'package:cmsc_23_project_group3/providers/auth_provider.dart';
import 'package:cmsc_23_project_group3/providers/user_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '/models/user_model.dart';
import 'company_detail.dart';

class DonorHome extends StatefulWidget {
  const DonorHome({super.key});

  @override
  State<DonorHome> createState() => _DonorHomeState();
}

class _DonorHomeState extends State<DonorHome> {
   @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<UserProvider>(context, listen: false).fetchOrganizations();
    });
  }

  User? user;

  Widget build(BuildContext context) {

    user = context.read<UserAuthProvider>().user;

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
                return const Center(child: Text('No organizations found'));
              } else {
                final organizations = snapshot.data!;
                return ListView.builder(
                  itemCount: organizations.length,
                  itemBuilder: (context, index) {
                    final organization = organizations[index];
                    return ListTile(
                      title: Text(organization.name), // Assuming `AppUser` has a `name` field
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CompanyDetailPage(companyName: organization.name, userId:user!.uid,companyId: organization.uid,),
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