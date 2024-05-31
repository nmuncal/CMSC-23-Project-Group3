import 'dart:io';

import 'package:cmsc_23_project_group3/models/donationDrive_model.dart';
import 'package:cmsc_23_project_group3/providers/donationdrive_provider.dart';
import 'package:cmsc_23_project_group3/styles.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../../../../providers/storage_provider.dart';

class AddDrive extends StatefulWidget {
  const AddDrive({Key? key}) : super(key: key);

  @override
  _AddDriveState createState() => _AddDriveState();
}

class _AddDriveState extends State<AddDrive> {
  final _formKey = GlobalKey<FormState>();
  final ImagePicker _picker = ImagePicker();
  File? _newCoverPhoto;
  String? _name;
  String? _details;
  bool _isOpen = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
          "Add Drive",
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
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                coverPhotoField(),
                nameField(),
                const SizedBox(height: 15),
                descriptionField(),
                isOpenSwitch(),
                submitButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget coverPhotoField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Drive Photo", style: TextStyle(color: Styles.mainBlue)),
        const SizedBox(height: 10),
        GestureDetector(
          onTap: () async {
            final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
            setState(() {
              if (pickedFile != null) {
                _newCoverPhoto = File(pickedFile.path);
              }
            });
          },
          child: Container(
            height: 150,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              image: _newCoverPhoto != null
                  ? DecorationImage(
                      image: FileImage(_newCoverPhoto!),
                      fit: BoxFit.cover,
                    )
                  : null,
            ),
            child: _newCoverPhoto == null
                ? const Center(
                    child: Icon(Icons.add_a_photo, size: 50, color: Colors.grey),
                  )
                : null,
          ),
        ),
        const SizedBox(height: 15),
      ],
    );
  }

  Widget nameField() {
    return TextFormField(
      decoration: InputDecoration(
        labelText: 'Drive name',
        border: OutlineInputBorder(),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter a name';
        }
        return null;
      },
      onChanged: (value) {
        _name = value;
      },
    );
  }

  Widget descriptionField() {
    return TextFormField(
      decoration: InputDecoration(
        labelText: 'Description',
        border: OutlineInputBorder(),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter a description';
        }
        return null;
      },
      onChanged: (value) {
        _details = value;
      },
    );
  }

  Widget isOpenSwitch() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: _isOpen
                ? const Text("Open for Donations", style: TextStyle(color: Colors.green))
                : const Text("Not Accepting Donations", style: TextStyle(color: Colors.red)),
          ),
          Expanded(
            flex: 1,
            child: Align(
              alignment: Alignment.centerRight,
              child: Switch(
                value: _isOpen,
                onChanged: (value) {
                  setState(() {
                    _isOpen = value;
                  });
                },
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget submitButton() {
    return ElevatedButton(
      onPressed: () {
        if (_formKey.currentState!.validate()) {
          handleAddDrive();
        }
      },
      child: const Text('Submit'),
    );
  }

  Future<void> handleAddDrive() async {
    final donationDriveProvider = context.read<DonationDriveProvider>();
    final storageProvider = context.read<UserStorageProvider>();


      final newDrive = DonationDrive(
        id: "",
        name: _name!,
        organizationid: "", // Fill with appropriate value
        details: _details!,
        status: _isOpen,
        donations: [],
      );

      String driveid = await donationDriveProvider.addDrive(newDrive);

      if (_newCoverPhoto != null) {
        String url = await storageProvider.uploadSingleFile(
              _newCoverPhoto!, "drives/$driveid");

        final updatedDrive = DonationDrive(
        id: "",
        name: _name!,
        organizationid: "", // Fill with appropriate value
        details: _details!,
        status: _isOpen,
        donations: [],
        photo: url
      );

      await donationDriveProvider.updateDriveDetails(driveid,updatedDrive).then((value) => Navigator.pop(context));
        
      }

      else{
        Navigator.pop(context);
      }
      


      Navigator.pop(context); // Navigate back after adding the drive

  }
}
