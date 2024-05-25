import 'package:cmsc_23_project_group3/models/user_model.dart';
import 'package:cmsc_23_project_group3/pages/views/organization/details/organization_details.dart';
import 'package:cmsc_23_project_group3/providers/user_provider.dart';
import 'package:cmsc_23_project_group3/styles.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class OrganizationDetailPage extends StatefulWidget {
  final String orgId;
  final bool pending;

  const OrganizationDetailPage({super.key, required this.orgId, required this.pending});

  @override
  State<OrganizationDetailPage> createState() => _OrganizationDetailPageState();
}

class _OrganizationDetailPageState extends State<OrganizationDetailPage> {
  @override
  Widget build(BuildContext context) {
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
      body: body(),
    );
  }

Widget body() {
  return Stack(
    children: [
      
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
        child: Align(
          alignment: Alignment.bottomCenter,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              viewProofButton(),
              if (widget.pending) ...[
                SizedBox(height: 10),
                approveButton(),
              ],
            ],
          ),
        ),
      ),

      OrganizationDetails(uid: widget.orgId),
    ],
  );
}

  Widget viewProofButton(){
    return GestureDetector(
      child: Styles.gradientButtonBuilder('View Proofs'), // Use gradientButtonBuilder from styles.dart
      onTap: () async {

      },

      // SIGN IN LOGIC
    );
  }

  bool approveButtonisPressed = false;
  Widget approveButton(){
    return GestureDetector(
      child: Styles.iconButtonBuilder(null, const Icon(Icons.check_rounded, color: Colors.white,), Colors.white, Colors.green, isPressed: approveButtonisPressed),
      onTap: () async {
        setState(() {
          approveButtonisPressed = true;
        });

        AppUser? details = context.read<UserProvider>().selectedUser;
        AppUser detailsCopy = details!.copyWith(isApproved: true);

        var message = await context.read<UserProvider>().updateUser(widget.orgId, detailsCopy);
        print(message);

        if (mounted){
          context.read<UserProvider>().getAccountInfo(null);
          Navigator.of(context).pop();
        }
      },

      // SIGN IN LOGIC
    );
  }
}