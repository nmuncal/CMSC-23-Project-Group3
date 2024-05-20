// Implement authentication
// Should default to sign in page
// After successful sign in user is redirected to their respective view depending on account type

import 'package:cmsc_23_project_group3/pages/views/admin_view.dart';
import 'package:cmsc_23_project_group3/pages/views/donor_view.dart';
import 'package:cmsc_23_project_group3/pages/views/organization_view.dart';
import 'package:cmsc_23_project_group3/providers/auth_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './signin_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int? accountType;
  bool? approvalStatus;

  @override
  void initState() {
    super.initState();
    getAccountType();
  }

  Future<void> getAccountType() async {
    try {
      final userAuthProvider = context.read<UserAuthProvider>();
      final newAccountType = await userAuthProvider.getAccountType();
      final newApprovalStatus = await userAuthProvider.getApprovalStatus();

      setState(() {
        accountType = newAccountType;
        approvalStatus = newApprovalStatus;
      });
    } catch (error) {
      print(error);
    }
  }

  Widget _buildLoadingIndicator() {
    return const Center(child: CircularProgressIndicator());
  }

  Widget _buildError(String message) {
    return Center(child: Text(message));
  }

  @override
  Widget build(BuildContext context) {
    Stream<User?> userStream = context.watch<UserAuthProvider>().userStream;

    return StreamBuilder<User?>(
      stream: userStream,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return _buildError(snapshot.error!.toString());
        } else if (snapshot.connectionState == ConnectionState.waiting) {
          return _buildLoadingIndicator();
        } else if (!snapshot.hasData) {
          return const SignInPage();
        } else {
          // User is logged in, use the fetched accountType
          print(accountType);

          if (accountType == 1 && approvalStatus == true){
            return const OrganizationView();
          } else if (accountType == 2){
            return const AdminView();
          } else {
            return const DonorView();
          }
        }
      },
    );
  }
}
