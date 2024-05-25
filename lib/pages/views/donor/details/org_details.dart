import 'package:cmsc_23_project_group3/api/firebase_user_api.dart';
import 'package:cmsc_23_project_group3/models/user_model.dart';
import 'package:cmsc_23_project_group3/pages/views/donor/details/donate_page.dart';
import 'package:cmsc_23_project_group3/pages/views/organization/details/donations_received_details.dart';
import 'package:cmsc_23_project_group3/pages/views/organization/details/organization_details.dart';
import 'package:cmsc_23_project_group3/providers/auth_provider.dart';
import 'package:cmsc_23_project_group3/providers/user_provider.dart';
import 'package:cmsc_23_project_group3/styles.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ViewOrganization extends StatefulWidget {
  String? orgId;
  ViewOrganization({super.key, this.orgId});

  @override
  State<ViewOrganization> createState() => _ViewOrganizationState();
}

class _ViewOrganizationState extends State<ViewOrganization> {
  
  late AppUser? org;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<UserProvider>().getAccountInfo(widget.orgId!);
    });
  }

  @override
  Widget build(BuildContext context) {

    org = context.watch<UserProvider>().selectedUser;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          color: Styles.mainBlue,
          onPressed: () {
            context.read<UserProvider>().getAccountInfo(null);
            Navigator.of(context).pop();
          },
        ), 
        backgroundColor: Colors.transparent,
        centerTitle: true,
      ),
      body: org == null ? const Center(child: CircularProgressIndicator()) : body(),
    );
  }

  

  Widget body() {

    return Stack(

      children: [

        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
          child:Align(
            alignment: Alignment.bottomCenter,
            child: !(org!.isOpen) ? closedButton() : donateButton(),        
          ),
        ),
        

        OrganizationDetails(uid: widget.orgId),     
      ]
    );
  }

  Widget closedButton(){
    return GestureDetector(
      onTap: () async {
        final ScaffoldMessengerState scaffoldMessenger = ScaffoldMessenger.of(context);
        scaffoldMessenger.removeCurrentSnackBar();
        scaffoldMessenger.showSnackBar(
          const SnackBar(
            content: Text("This organization is currently not accepting donations."),
            duration: Duration(seconds: 2),
          ),
        );
      },
      child: Styles.iconButtonBuilder(
        null,
        Icon(
          Icons.do_not_disturb_alt_outlined,
          color: Styles.mainBlue,
        ),
        Styles.mainBlue,
        null,
      ),
    );
  }

  Widget donateButton(){
    return GestureDetector(
      child: Styles.gradientButtonBuilder('Donate'), // Use gradientButtonBuilder from styles.dart
      onTap: () async {

        context.read<UserProvider>().getAccountInfo(widget.orgId!);
        
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DonatePage(
              companyName: context.read<UserProvider>().selectedUser!.name, 
              userId: context.read<UserAuthProvider>().user!.uid, 
              companyId: widget.orgId!
            ),
          ),
        );
      },

      // SIGN IN LOGIC
    );
  }
}