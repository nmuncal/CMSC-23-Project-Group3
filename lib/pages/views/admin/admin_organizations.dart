import 'package:cmsc_23_project_group3/pages/views/admin/details/org_details.dart';
import 'package:cmsc_23_project_group3/providers/user_provider.dart';
import 'package:cmsc_23_project_group3/styles.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '/models/user_model.dart';

class AdminOrganizations extends StatefulWidget {
  const AdminOrganizations({super.key});

  @override
  State<AdminOrganizations> createState() => _OrganizationHomeState();
}

class _OrganizationHomeState extends State<AdminOrganizations> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<UserProvider>().getAccountInfo(null);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      body: Consumer<UserProvider>(
        builder: (context, userProvider, child) {
          return StreamBuilder<List<AppUser>>(
            stream: userProvider.orgStream,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Center(child: Text('No organizations found'));
              } else {
                final organizations = snapshot.data!;
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: ListView.builder(
                    itemCount: organizations.length,
                    itemBuilder: (context, index) {
                      final org = organizations[index];
                      return componentTiles(org);          
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
                  color: user.isOpen ? Colors.green : Colors.red,
                  width: 1.5,
                ),
                shape: BoxShape.circle,
              ),
            ),
          ),
        ],
      ),
      title: Text(user.name),
      trailing: Icon(Icons.navigate_next_rounded, color: Styles.darkerGray),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => OrganizationDetailPage(orgId: user.uid, pending: false),
          ),
        );
      },
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      title: const Text('Organizations'),
      automaticallyImplyLeading: false, // This removes the back button
    );
  }
}