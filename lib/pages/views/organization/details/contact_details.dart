// ignore_for_file: must_be_immutable

import 'package:cmsc_23_project_group3/models/user_model.dart';
import 'package:cmsc_23_project_group3/styles.dart';
import 'package:flutter/material.dart';

class ContactDetails extends StatelessWidget {
  late AppUser? user;
  ContactDetails({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Divider(
            height: 15,
            thickness: 1,
            color: Styles.darkerGray,
          ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Table(
            columnWidths: const {
              0: FlexColumnWidth(1),
              1: FlexColumnWidth(2),
            },
            children: [
              TableRow(
                
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Center(
                      child: Text(
                        "Email",
                        style: TextStyle(color: Styles.mainBlue),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Center(child: Text(user!.email)),
                  ),
                ],
              ),

               TableRow(children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Center(
                    child: Text("Account Type", style: TextStyle(color: Styles.mainBlue)),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Center(
                    child: Text(user!.accountType == 0 ? "Donor" : 
                    (user!.accountType == 1 ? "Organization" : "Admin")),
                  ),
                ),
                
              ]),
              
              TableRow(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Center(
                      child: Text(
                        "Contact",
                        style: TextStyle(color: Styles.mainBlue),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Center(child: Text(user!.contactNo)),
                  ),
                ],
              ),
              
              TableRow(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Center(
                      child: Text(
                        "Address/es",
                        style: TextStyle(color: Styles.mainBlue),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Center(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: user!.address
                            .map((address) => Text(address))
                            .toList(),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        Divider(
          height: 15,
          thickness: 1,
          color: Styles.darkerGray,
        ),
      ],
    );
  }
}