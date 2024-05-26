import 'package:cmsc_23_project_group3/pages/views/admin/details/org_details.dart';
import 'package:cmsc_23_project_group3/providers/user_provider.dart';
import 'package:cmsc_23_project_group3/styles.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '/models/user_model.dart';

class AdminPending extends StatefulWidget {
  const AdminPending({super.key});

  @override
  State<AdminPending> createState() => _PendingOrganizationHomeState();
}

class _PendingOrganizationHomeState extends State<AdminPending> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<UserProvider>(context, listen: false).fetchPendingOrganizations();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      body: Consumer<UserProvider>(
        builder: (context, userProvider, child) {
          return StreamBuilder<List<AppUser>>(
            stream: userProvider.pendingOrgStream,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Center(child: Text('No pending organizations found'));
              } else {
                final pendingOrgs = snapshot.data!;
                return ListView.builder(
                  itemCount: pendingOrgs.length,
                  itemBuilder: (context, index) {
                    final pendingOrg = pendingOrgs[index];
                    return componentTiles(pendingOrg);
                  },
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
      contentPadding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
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
      trailing: const Icon(Icons.navigate_next_rounded),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => OrganizationDetailPage(orgId: user.uid, pending: true),
          ),
        );
      }
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      title: const Text('Pending'),
      automaticallyImplyLeading: false, // This removes the back button
    );
  }
}
