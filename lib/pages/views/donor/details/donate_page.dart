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

class DonatePage extends StatefulWidget {
  final String companyName;
  final String companyId;
  final String userId;

  const DonatePage(
      {super.key,
      required this.companyName,
      required this.userId,
      required this.companyId});

  @override
  _DonatePageState createState() => _DonatePageState();
}

class _DonatePageState extends State<DonatePage> {
  List<String> donatedItems = [];
  String others = '';
  bool pickUp = false;
  String weight = '';
  String status = 'Pending';
  List<String> addresses = [];
  String donationDrive = '';
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
                value: donatedItems.contains('Food'),
                onChanged: (newValue) {
                  setState(() {
                    if (newValue == true) {
                      donatedItems.add('Food');
                    } else {
                      donatedItems.remove('Food');
                    }
                  });
                },
              ),
              CheckboxListTile(
                title: Text('Clothes'),
                value: donatedItems.contains('Clothes'),
                onChanged: (newValue) {
                  setState(() {
                    if (newValue == true) {
                      donatedItems.add('Clothes');
                    } else {
                      donatedItems.remove('Clothes');
                    }
                  });
                },
              ),
              CheckboxListTile(
                title: Text('Cash'),
                value: donatedItems.contains('Cash'),
                onChanged: (newValue) {
                  setState(() {
                    if (newValue == true) {
                      donatedItems.add('Cash');
                    } else {
                      donatedItems.remove('Cash');
                    }
                  });
                },
              ),
              CheckboxListTile(
                title: Text('Necessities'),
                value: donatedItems.contains('Necessities'),
                onChanged: (newValue) {
                  setState(() {
                    if (newValue == true) {
                      donatedItems.add('Necessities');
                    } else {
                      donatedItems.remove('Necessities');
                    }
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

        if (others != '') {
          donatedItems.add(others);
        }

        Donation temp;

        if (pickUp == true) {
          temp = Donation(
            donatedItems: donatedItems,
            isPickup: pickUp,
            weight: weight,
            addressForPickup: addresses,
            donorId: widget.userId,
            recipientId: widget.companyId,
            status: status,
            contactNumber: contactNumber,
            selectedDateandTime: Timestamp.fromDate(selectedDateTime),
          );
        } else {
          temp = Donation(
            donatedItems: donatedItems,
            isPickup: pickUp,
            weight: weight,
            donorId: widget.userId,
            recipientId: widget.companyId,
            status: status,
            selectedDateandTime: Timestamp.fromDate(selectedDateTime),
          );
        }

        String donationId = await donationProvider.addDonation(temp);

        if (_image != null) {
          String url = await userStorageProvider.uploadSingleFile(
              _image!, "donations/$donationId");

          Donation details = Donation(donatedItems: donatedItems, isPickup: pickUp, weight: weight, donorId: widget.userId, recipientId: widget.companyId, status: status, selectedDateandTime: Timestamp.fromDate(selectedDateTime),url: url);

          await donationProvider.updateDonation(donationId, details);
        }
      }
    } catch (error) {
      print("Error during donation sending: $error");
    }
  }
}
