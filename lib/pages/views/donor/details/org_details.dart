import 'package:cmsc_23_project_group3/api/firebase_user_api.dart';
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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          color: Styles.mainBlue,
          onPressed: () => Navigator.of(context).pop(),
        ), 
        backgroundColor: Colors.transparent,
        centerTitle: true,
      ),
      body: body(),
    );
  }

  Widget body() {
    return Stack(

      children: [

        Padding(
          padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
          child:Align(
            alignment: Alignment.bottomCenter,
            child:donateButton(),        
          ),
        ),
        

        OrganizationDetails(uid: widget.orgId),     
      ]
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
            builder: (context) => DonatePage(companyName: '', userId: context.read<UserAuthProvider>().user!.uid, companyId: widget.orgId!),
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