// Implement authentication
// Should default to sign in page
// After successful sign in user is redirected to their respective view depending on account type

import 'package:cmsc_23_project_group3/models/user_model.dart';
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
  AppUser? user;

  @override
  Widget build(BuildContext context) {
    Stream<User?> userStream = context.watch<UserAuthProvider>().userStream;
    user = context.watch<UserAuthProvider>().accountInfo;

    return StreamBuilder<User?>(
      stream: userStream,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(child: Text(snapshot.error!.toString()));
        } else if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (!snapshot.hasData || user == null) {
          return const SignInPage();
        } else {
          
          if (user!.accountType == 1){
            return const OrganizationView();
          } else if (user!.accountType == 2){
            return const AdminView();
          } else {
            return const DonorView();
          }
        }
      },
    );
  }
}
