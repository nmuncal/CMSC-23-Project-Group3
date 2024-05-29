import 'dart:io';

import 'package:cmsc_23_project_group3/models/user_model.dart';
import 'package:cmsc_23_project_group3/providers/user_provider.dart';
import 'package:cmsc_23_project_group3/styles.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../../../../providers/storage_provider.dart';

class EditOrganization extends StatefulWidget {
  
  final String orgId;

  const EditOrganization({Key? key, required this.orgId}) : super(key: key);

  @override
  _EditOrganizationState createState() => _EditOrganizationState();
}

class _EditOrganizationState extends State<EditOrganization> {
  final storageProvider = UserStorageProvider();
  late AppUser? org;
  XFile? newProfilePhoto;
  XFile? newCoverPhoto;
  final ImagePicker _picker = ImagePicker();

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
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              backgroundColor: Colors.white,
            ),
            body: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    disabledFields(),
                    Divider(
                      height: 30,
                      thickness: 1,
                      color: Styles.darkerGray,
                    ),
                    profilePhotoField(),
                    coverPhotoField(),
                    org!.accountType == 1 ? isOpenSwitch() : Container(),
                    descriptionField(),
                    Divider(
                      height: 30,
                      thickness: 1,
                      color: Styles.darkerGray,
                    ),
                    addressField(),
                    const SizedBox(height: 15),
                    contactField(),
                    const SizedBox(height: 25),
                    submitButton(),
                    const SizedBox(height: 15),
                  ],
                ),
              ),
            ),
          );
  }

  Widget addressField() {
    const int maxAddressCount = 5;
    List<Widget> addressWidgets = [];

    addressWidgets.add(
      Text("Address/es", style: TextStyle(color: Styles.mainBlue)),
    );

    for (int i = 0; i < org!.address.length; i++) {
      addressWidgets.add(
        Row(
          children: [
            Expanded(
              child: TextFormField(
                initialValue: org!.address[i],
                decoration: Styles.textFieldStyle("Address ${i + 1}"),
                onChanged: (value) {
                  org!.address[i] = value;
                },
              ),
            ),
            i != 0
                ? IconButton(
                    icon: const Icon(Icons.remove_circle),
                    onPressed: () {
                      setState(() {
                        org!.address.removeAt(i);
                      });
                    },
                  )
                : Container(),
          ],
        ),
      );
      addressWidgets.add(const SizedBox(height: 10));
    }

    bool canAddAddress = org!.address.length < maxAddressCount;

    addressWidgets.add(
      Center(
        child: ElevatedButton(
          onPressed: canAddAddress
              ? () {
                  setState(() {
                    org!.address.add("");
                  });
                }
              : null, // Set onPressed to null when button is disabled
          child: Text("Add Address"),
        ),
      ),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: addressWidgets,
    );
  }

  Widget profilePhotoField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Profile Photo", style: TextStyle(color: Styles.mainBlue)),
        const SizedBox(height: 10),
        GestureDetector(
          onTap: () async {
            final pickedFile =
                await _picker.pickImage(source: ImageSource.gallery);
            setState(() {
              newProfilePhoto = pickedFile;
            });
          },
          child: CircleAvatar(
            radius: 50,
            backgroundImage: newProfilePhoto != null
                ? FileImage(File(newProfilePhoto!.path))
                : org!.profilePhoto.isNotEmpty
                    ? NetworkImage(org!.profilePhoto)
                    : null as ImageProvider?,
            child: newProfilePhoto == null && org!.profilePhoto.isEmpty
                ? const Icon(Icons.add_a_photo, size: 50, color: Colors.grey)
                : null,
          ),
        ),
        const SizedBox(height: 15),
      ],
    );
  }

  Widget coverPhotoField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Cover Photo", style: TextStyle(color: Styles.mainBlue)),
        const SizedBox(height: 10),
        GestureDetector(
          onTap: () async {
            final pickedFile =
                await _picker.pickImage(source: ImageSource.gallery);
            setState(() {
              newCoverPhoto = pickedFile;
            });
          },
          child: Container(
            height: 150,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              image: newCoverPhoto != null
                  ? DecorationImage(
                      image: FileImage(File(newCoverPhoto!.path)),
                      fit: BoxFit.cover,
                    )
                  : org!.coverPhoto.isNotEmpty
                      ? DecorationImage(
                          image: NetworkImage(org!.coverPhoto),
                          fit: BoxFit.cover,
                        )
                      : null,
            ),
            child: newCoverPhoto == null && org!.coverPhoto.isEmpty
                ? const Center(
                    child: Icon(Icons.add_a_photo, size: 50, color: Colors.grey))
                : null,
          ),
        ),
        const SizedBox(height: 15),
      ],
    );
  }

  Widget descriptionField() {
    return TextFormField(
      decoration: Styles.textFieldStyle(
              org!.desc != "" ? org!.desc : "Description")
          .copyWith(
        contentPadding: const EdgeInsets.symmetric(
            vertical: 20.0, horizontal: 10.0), // Modify height here
      ),
      enabled: true,
      maxLines: 5, // Allow for more lines of text
      initialValue: org!.desc,
      onChanged: (value) {
        org!.desc = value;
      },
    );
  }

  Widget disabledFields() {
    return Table(
      columnWidths: const {
        0: FlexColumnWidth(1),
        1: FlexColumnWidth(2),
      },
      children: [
        TableRow(children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Center(
              child: Text("Name", style: TextStyle(color: Styles.mainBlue)),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Center(
              child: Text(org!.name),
            ),
          ),
        ]),
        TableRow(children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Center(
              child:
                  Text("Username", style: TextStyle(color: Styles.mainBlue)),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Center(
              child: Text(org!.username),
            ),
          ),
        ]),
        TableRow(children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Center(
              child: Text("Email", style: TextStyle(color: Styles.mainBlue)),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Center(
              child: Text(org!.email),
            ),
          ),
        ]),
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
              child: Text(org!.accountType == 0 ? "Donor" : 
              (org!.accountType == 1 ? "Organization" : "Admin")),
            ),
          ),
          
        ]),
      ],
    );
  }

  Widget contactField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Contact no.", style: TextStyle(color: Styles.mainBlue)),
        TextFormField(
          initialValue: org!.contactNo,
          decoration: Styles.textFieldStyle(org!.contactNo),
          enabled: true,
          onChanged: (value) {
            org!.contactNo = value;
          },
        ),
      ],
    );
  }

  bool? newIsOpen;

  Widget isOpenSwitch() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: (newIsOpen ?? org!.isOpen)
                ? const Text("Open for Donations",
                    style: TextStyle(
                      color: Colors.green,
                    ))
                : const Text("Not Accepting Donations",
                    style: TextStyle(color: Colors.red)),
          ),
          Expanded(
            flex: 1,
            child: Align(
              alignment: Alignment.centerRight,
              child: Switch(
                value: newIsOpen ?? org!.isOpen,
                onChanged: (value) {
                  setState(() {
                    newIsOpen = value;
                  });
                },
              ),
            ),
          )
        ],
      ),
    );
  }

  bool _submitPressed = false;
  Widget submitButton() {
    return GestureDetector(
      onTap: () async {
        setState(() {
          _submitPressed = true;
        });

        String profilePhotoUrl = newProfilePhoto != null
          ? await storageProvider.uploadSingleFile(
              File(newProfilePhoto!.path), "users/${org!.uid}/profileImages")
          : org!.profilePhoto;

        String coverPhotoUrl = newCoverPhoto != null
          ? await storageProvider.uploadSingleFile(
              File(newCoverPhoto!.path), "users/${org!.uid}/coverImages")
          : org!.coverPhoto;

        AppUser updatedUser = org!.copyWith(
          profilePhoto: newProfilePhoto != null ? profilePhotoUrl : org!.profilePhoto,
          coverPhoto: newCoverPhoto != null ? coverPhotoUrl : org!.coverPhoto,
          desc: org!.desc,
          isOpen: newIsOpen ?? org!.isOpen,
          address: List.from(org!.address),
          contactNo: org!.contactNo,
        );

        if (mounted){
          await context.read<UserProvider>().updateUser(updatedUser);
        }
        
        setState(() {
          _submitPressed = false;
        });
      },
      child: Styles.gradientButtonBuilder('Submit', isPressed: _submitPressed),
    );
  }
}

