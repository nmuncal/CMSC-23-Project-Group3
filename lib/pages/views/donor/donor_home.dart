import 'package:cmsc_23_project_group3/providers/auth_provider.dart';
import 'package:cmsc_23_project_group3/providers/user_provider.dart';
import 'package:cmsc_23_project_group3/styles.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '/models/user_model.dart';
import 'details/org_details.dart';

class DonorHome extends StatefulWidget {
  const DonorHome({super.key});

  @override
  State<DonorHome> createState() => _DonorHomeState();
}

class _DonorHomeState extends State<DonorHome> {

  final ScrollController _scrollController = ScrollController(); 

   @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<UserProvider>().getAccountInfo(null);
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
                  padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                  child: ListView.builder(
                    controller: _scrollController,
                    itemCount: organizations.length,
                    itemBuilder: (context, index) {
                      final organization = organizations[index];
                      return componentTiles(organization, index);
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

Widget componentTiles(AppUser user, int index) {
  return GestureDetector(
    onTap: () => _navigateToOrganization(context, user),
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
              _buildCoverImage(user, index),
              _buildGradientOverlay(context, user),
            ],
          ),
        ),
      ),
    );
  }

Widget _buildCoverImage(AppUser user, int index) {
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
                user.coverPhoto != '' ? user.coverPhoto : Styles.defaultCover,
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



  Widget _buildGradientOverlay(BuildContext context, user) {
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
          child: _buildTextContent(user),
        ),
      );
  }

Widget _buildTextContent(AppUser user) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Row(
        children: [
          Text(
            user.name,
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
              color: user.isOpen ? Colors.green : Colors.red,
            ),
          ),
        ],
      ),
      const SizedBox(height: 5),
      Text(
        user.desc.isNotEmpty ? user.desc : "This organization is still crafting their story!",
        style: const TextStyle(color: Colors.white70),
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      ),
    ],
  );
}


  void _navigateToOrganization(BuildContext context, AppUser user) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ViewOrganization(orgId: user.uid),
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