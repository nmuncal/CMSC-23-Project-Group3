import 'package:cmsc_23_project_group3/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DonorProfile extends StatefulWidget {
  const DonorProfile({super.key});

  @override
  State<DonorProfile> createState() => _DonorProfileState();
}

class _DonorProfileState extends State<DonorProfile> {
  @override
  Widget build(BuildContext context) {
    return  ElevatedButton(
              onPressed:  () {
                context.read<UserAuthProvider>().signOut();
              },

              child: Text('Sign Out'),
            );
  }
}