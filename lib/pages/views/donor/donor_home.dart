import 'package:cmsc_23_project_group3/providers/auth_provider.dart';
import 'package:cmsc_23_project_group3/providers/user_provider.dart';
import 'package:cmsc_23_project_group3/styles.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '/models/user_model.dart';
import 'details/org_details.dart';

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
                      final organization = organizations[index];
                      return componentTiles(organization);
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
  return Card(
    elevation: 1,
    color: Colors.white,
    shape: RoundedRectangleBorder(
      borderRadius: Styles.rounded,
    ),
    child: ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
      leading: Stack(
        children: [
          CircleAvatar(
            backgroundImage: NetworkImage(
              user.profilePhoto != '' ? user.profilePhoto : Styles.defaultProfile,
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
      title: Text(user.name, style: TextStyle(color: Styles.mainBlue, fontSize: 24), maxLines: 1, overflow: TextOverflow.ellipsis,
      ),
      subtitle: Column( // Use Column for vertical layout
        crossAxisAlignment: CrossAxisAlignment.start, // Align text to the left
        children: [
          Text("@${user.username}", style: TextStyle(color: Styles.lightestBlue, fontStyle: FontStyle.italic)),
          const SizedBox(height: 5),
          Text(
            user.desc != '' ? user.desc : "This organization is still crafting their story!",
            style: const TextStyle(color: Colors.black54),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
      trailing: Icon(Icons.navigate_next_rounded, color: Styles.darkerGray),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ViewOrganization(orgId: user.uid),
          ),
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