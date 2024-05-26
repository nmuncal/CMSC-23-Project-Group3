import 'package:cmsc_23_project_group3/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AdminProfile extends StatefulWidget {
  const AdminProfile({super.key});

  @override
  State<AdminProfile> createState() => _AdminProfileState();
}

class _AdminProfileState extends State<AdminProfile> {
  @override
  Widget build(BuildContext context) {
    return  TextButton(
              onPressed:  () {
                context.read<UserAuthProvider>().signOut();
              },

              child: Text('Sign Out'),
            );
  }
}