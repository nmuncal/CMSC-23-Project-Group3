// Implement authentication
// Should default to sign in page
// After successful sign in user is redirected to their respective view depending on account type

import 'package:flutter/material.dart';
import './signin_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return const SignInPage();    // No pushing of navigator here just direct call

    // For example:
    // If not signed in => SignInPage()
    // else switch (0 => DonorView(); 1 => OrgView(); 2 => AdminView())

  }
}