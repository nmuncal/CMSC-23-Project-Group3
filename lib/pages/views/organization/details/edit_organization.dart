// ignore_for_file: must_be_immutable

import 'package:cmsc_23_project_group3/models/user_model.dart';
import 'package:cmsc_23_project_group3/providers/user_provider.dart';
import 'package:cmsc_23_project_group3/styles.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EditOrganization extends StatefulWidget {
  late String orgId;
  EditOrganization({super.key, required this.orgId});

  @override
  State<EditOrganization> createState() => _EditOrganizationState();
}

class _EditOrganizationState extends State<EditOrganization> {

  AppUser? org;
  
  @override
  Widget build(BuildContext context) {

    org = context.watch<UserProvider>().selectedUser;

    return org == null
      ? const Center(child: CircularProgressIndicator())
      : Scaffold(
        appBar: AppBar(
          scrolledUnderElevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
            color: Styles.mainBlue,
          ),
          title: Text(
            org!.name,
            style: TextStyle(
                color: Styles.mainBlue,
                fontSize: 36,
                fontWeight: FontWeight.bold),
          ),
          backgroundColor: Colors.white,
        ),
        body: body());
  }

  Widget body(){
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: SingleChildScrollView(
      child: Column(
        children: [
          disabledFields(),
          isOpenSwitch(),
        ],
      )
    )
    );
  }

  Widget disabledFields(){
    return Column(
      children: [
        const SizedBox(height: 15),
        const SizedBox(height: 15),
        emailField()
      ],
    );
  }
  
  Widget usernameField() {
    return TextFormField(
      decoration:
          Styles.textFieldStyle(org!.username), // Use the builder from styles.dart
      enabled: false,
    );
  }

  Widget emailField() {
    return TextFormField(
      decoration:
          Styles.textFieldStyle(org!.email), // Use the builder from styles.dart
      enabled: false,
    );
  }

  bool? newIsOpen;
  Widget isOpenSwitch() {

    return Row(
      children: [
        Expanded(
          flex: 2,
          child: (newIsOpen ?? org!.isOpen)
            ? const Text("Open for Donations", style: TextStyle(color: Colors.green,))
            : const Text("Not Accepting Donations", style: TextStyle(color: Colors.red)),
          
        ),
        Expanded(
          flex: 1,
          child: Switch(
          value: newIsOpen ?? org!.isOpen,
          onChanged: (value) {
            setState(() {
              newIsOpen = value;
            });
          },
          ),
        )
        
      ],
    );
  }

  Widget addressField(){
    return ListView.builder(
      itemCount: org!.address.length,
      itemBuilder: (context, index) {
        return TextFormField(
          decoration:
              Styles.textFieldStyle(org!.address[index]), // Use the builder from styles.dart
          enabled: true,
        );
      },
    );
  }

}