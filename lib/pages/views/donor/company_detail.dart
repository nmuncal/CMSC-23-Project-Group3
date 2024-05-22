import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cmsc_23_project_group3/models/donation_model.dart';
import 'package:cmsc_23_project_group3/models/user_model.dart';
import 'package:cmsc_23_project_group3/providers/donation_provider.dart';
import 'package:cmsc_23_project_group3/providers/storage_provider.dart';
import 'package:cmsc_23_project_group3/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

import 'package:provider/provider.dart';

class CompanyDetailPage extends StatefulWidget {
  final String companyName;
  final String companyId;
  final String userId;

  const CompanyDetailPage(
      {super.key,
      required this.companyName,
      required this.userId,
      required this.companyId});

  @override
  _CompanyDetailPageState createState() => _CompanyDetailPageState();
}

class _CompanyDetailPageState extends State<CompanyDetailPage> {
  bool food = false;
  bool clothes = false;
  bool cash = false;
  bool necessities = false;
  String others = '';
  bool pickUp = false;
  String weight = '';
  String status = 'pending';
  List<String> addresses = [];
  String contactNumber = '';
  DateTime? selectedDate;
  TimeOfDay? selectedTime;
  File? _image;
  final picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.companyName),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Select Donation Types:'),
              CheckboxListTile(
                title: Text('Food'),
                value: food,
                onChanged: (newValue) {
                  setState(() {
                    food = newValue!;
                  });
                },
              ),
              CheckboxListTile(
                title: Text('Clothes'),
                value: clothes,
                onChanged: (newValue) {
                  setState(() {
                    clothes = newValue!;
                  });
                },
              ),
              CheckboxListTile(
                title: Text('Cash'),
                value: cash,
                onChanged: (newValue) {
                  setState(() {
                    cash = newValue!;
                  });
                },
              ),
              CheckboxListTile(
                title: Text('Necessities'),
                value: necessities,
                onChanged: (newValue) {
                  setState(() {
                    necessities = newValue!;
                  });
                },
              ),
              SizedBox(height: 20),
              Text('Other Donation Type:'),
              TextFormField(
                onChanged: (value) {
                  setState(() {
                    others = value;
                  });
                },
                decoration: InputDecoration(
                  hintText: 'Enter other donation type',
                ),
              ),
              SizedBox(height: 20),
              Text('Pick Up or Drop Off:'),
              Switch(
                value: pickUp,
                onChanged: (newValue) {
                  setState(() {
                    pickUp = newValue;
                  });
                },
              ),
              if (pickUp) ...[
                SizedBox(height: 20),
                Text('Addresses for Pick Up:'),
                Column(
                  children: addresses.map((address) => Text(address)).toList(),
                ),
                ElevatedButton(
                  onPressed: _addAddress,
                  child: Text('Add Address'),
                ),
                SizedBox(height: 20),
                Text('Contact Number for Pick Up:'),
                TextFormField(
                  onChanged: (value) {
                    setState(() {
                      contactNumber = value;
                    });
                  },
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(
                    hintText: 'Enter contact number',
                  ),
                ),
              ],
              SizedBox(height: 20),
              Text('Weight of Items (kg):'),
              TextFormField(
                onChanged: (value) {
                  setState(() {
                    weight = value;
                  });
                },
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  hintText: 'Enter weight in kilograms',
                ),
              ),
              SizedBox(height: 20),
              Text('Date for Pick Up/Drop Off:'),
              ElevatedButton(
                onPressed: _selectDate,
                child: Text(selectedDate == null
                    ? 'Select Date'
                    : 'Selected Date: ${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}'),
              ),
              SizedBox(height: 20),
              Text('Time for Pick Up/Drop Off:'),
              ElevatedButton(
                onPressed: _selectTime,
                child: Text(selectedTime == null
                    ? 'Select Time'
                    : 'Selected Time: ${selectedTime!.hour}:${selectedTime!.minute}'),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _getImageFromGallery,
                child: Text('Upload Photo'),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _takePhoto,
                child: Text('Take Photo'),
              ),
              if (_image != null) ...[
                SizedBox(height: 20),
                Image.file(
                  _image!,
                  width: 200,
                  height: 200,
                ),
              ],
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  _handleSendDonation();
                  Navigator.pop(context);
                },
                child: Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _getImageFromGallery() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      }
    });
  }

  Future<void> _takePhoto() async {
    final pickedFile = await picker.pickImage(source: ImageSource.camera);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      }
    });
  }

  void _selectDate() async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (pickedDate != null && pickedDate != selectedDate) {
      setState(() {
        selectedDate = pickedDate;
      });
    }
  }

  void _selectTime() async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (pickedTime != null && pickedTime != selectedTime) {
      setState(() {
        selectedTime = pickedTime;
      });
    }
  }

  void _addAddress() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        String newAddress = '';
        return AlertDialog(
          title: Text('Add Address'),
          content: TextField(
            onChanged: (value) {
              newAddress = value;
            },
            decoration: InputDecoration(hintText: 'Enter address'),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Add'),
              onPressed: () {
                setState(() {
                  addresses.add(newAddress);
                });
                Navigator.of(context).pop();

              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _handleSendDonation() async {
    try {
      if (selectedDate != null && selectedTime != null) {
        final selectedDateTime = DateTime(
          selectedDate!.year,
          selectedDate!.month,
          selectedDate!.day,
          selectedTime!.hour,
          selectedTime!.minute,
        );

        final userProvider = context.read<UserProvider>();
        final donationProvider = context.read<DonationProvider>();
        final userStorageProvider = context.read<UserStorageProvider>();

        AppUser? userDetails = await userProvider.getAccountInfo(widget.userId);

        if (userDetails != null) {
          Donation temp = Donation(
              food: food,
              clothes: clothes,
              cash: cash,
              necessities: necessities,
              isPickup: pickUp,
              weight: weight,
              addressForPickup: addresses,
              recipientName: widget.companyName,
              donorName: userDetails.name,
              status: status,
              contactNumber: contactNumber,
              selectedDateandTime: Timestamp.fromDate(selectedDateTime));

          try {
            String donationGivenId = await donationProvider.addDonation(
                temp, widget.userId, "donor");

            String donationRecipientId = await donationProvider.addDonation(
                temp, widget.companyId, "recipient");

            if (_image != null) {
              try {
                await userStorageProvider.uploadSingleFile(_image!,
                    "${widget.userId}/donationsGiven/$donationGivenId");
                await userStorageProvider.uploadSingleFile(_image!,
                    "${widget.companyId}/donationsReceived/$donationRecipientId");
              } catch (e) {
                print("$e");
              }
            }
          } catch (e) {
            print("Unable to send donation : $e");
          }
        }
      }
    } catch (error) {
      // Handle any errors
      print("Error during donation sending: $error");
    }
  }
}
