import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cmsc_23_project_group3/models/donation_model.dart';
import 'package:cmsc_23_project_group3/providers/donation_provider.dart';
import 'package:cmsc_23_project_group3/providers/storage_provider.dart';
import 'package:cmsc_23_project_group3/styles.dart';
import 'package:google_fonts/google_fonts.dart';

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

  bool _isFormFilled() {
  return donatedItems.isNotEmpty ||
      others.isNotEmpty ||
      pickUp ||
      weight.isNotEmpty ||
      addresses.isNotEmpty ||
      contactNumber.isNotEmpty ||
      selectedDate != null ||
      selectedTime != null ||
      _image != null;
}

bool _areRequiredFieldsFilled() {
  if (donatedItems.isEmpty) {
    return false;
  }

  if (pickUp) {
    if (addresses.isEmpty || contactNumber.isEmpty) {
      return false;
    }
  }

  return weight.isNotEmpty && selectedDate != null && selectedTime != null;
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:_buildAppBar(context, Text(
        'tayo',
        style: GoogleFonts.quicksand(
          color: Styles.mainBlue,
          fontWeight: FontWeight.bold,
          fontSize: 30,
        ),
      ),),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(child: Text('${widget.companyName} Donations'.toUpperCase() , style: GoogleFonts.quicksand(color: Styles.lightestBlue, fontSize: 20, fontWeight: FontWeight.bold))),
              Divider(),
              SizedBox(height: 20),
              toggleSwitch(),
              SizedBox(height: 20),
              donationCheckbox(),
              SizedBox(height: 20),
 if (pickUp) ...[
  Center(
    child: Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Text(
            'Address',
            style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
          ),
        ),
        Column(
          children: addresses.map((address) => Padding(
            padding: const EdgeInsets.symmetric(vertical: 4.0),
            child: Text(
              address,
              style: TextStyle(
                fontSize: 16,
                color: Colors.black87,
              ),
            ),
          )).toList(),
        ),
        SizedBox(height: 10),
        ElevatedButton.icon(
          onPressed: _addAddress,
          icon: Icon(Icons.add, color: Styles.mainBlue),
          label: Text('Add Address'),
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
        SizedBox(height: 10),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Text(
            'Contact Number',
            style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: TextFormField(
            onChanged: (value) {
              setState(() {
                contactNumber = value; // Update contactNumber when the value changes
              });
            },
            keyboardType: TextInputType.phone,
            decoration: InputDecoration(
              hintText: 'Enter Contact Number',
              contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.blue, width: 1.5),
                borderRadius: BorderRadius.circular(12),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.blue, width: 2.0),
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),
      ],
    ),
  ),
],

            SizedBox(height: 20),
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 8.0),
          child: Text(
            'Weight of Items (kg)',
            style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
          ),
        ),
Padding(
  padding: const EdgeInsets.symmetric(vertical: 8.0),
  child: TextFormField(
    onChanged: (value) {
      setState(() {
        weight = value;
      });
    },
    keyboardType: TextInputType.number,
    decoration: InputDecoration(
      hintText: 'Enter weight in kilograms',
      contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.blue, width: 1.5),
        borderRadius: BorderRadius.circular(12),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.blue, width: 2.0),
        borderRadius: BorderRadius.circular(12),
      ),
    ),
  ),
),
SizedBox(height: 20),
Center(child: 
SingleChildScrollView(
  scrollDirection: Axis.horizontal,
  child: Row(
    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    children: [
      Column(
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 8.0),
            child: Text(
              'Date',
              style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
            ),
          ),
          ElevatedButton(
            onPressed: _selectDate,
            child: Text(
              selectedDate == null
                  ? 'Select Date'
                  : 'Selected Date: ${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}',
            ),
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ],
      ),
      SizedBox(width: 20), // Add spacing between date and time pickers
      Column(
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 8.0),
            child: Text(
              'Time',
              style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
            ),
          ),
          ElevatedButton(
            onPressed: _selectTime,
            child: Text(
              selectedTime == null
                  ? 'Select Time'
                  : 'Selected Time: ${selectedTime!.hour}:${selectedTime!.minute}',
            ),
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ],
      ),
    ],
  ),
), 
),

Center(child: 
Column(children: [
SizedBox(height: 20),
ElevatedButton(
  onPressed: _getImageFromGallery,
  child: Text('Upload Photo'),
  style: ElevatedButton.styleFrom(

    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
    ),
  ),
),
SizedBox(height: 20),
ElevatedButton(
  onPressed: _takePhoto,
  child: Text('Take Photo'),
  style: ElevatedButton.styleFrom(

    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
    ),
  ),
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
  },
  child: Text('Submit'),
  style: ElevatedButton.styleFrom(

    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
    ),
  ),
),],),),

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
            newAddress = value.trim(); // Trim leading and trailing spaces
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
              if (newAddress.isNotEmpty) { // Check if the trimmed address is not empty
                setState(() {
                  addresses.add(newAddress);
                });
              }
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}


Future<void> _handleSendDonation() async {
  if (!_areRequiredFieldsFilled()) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Please fill in all required fields.'),
      ),
    );
    return;
  }

  try {
    if (selectedDate != null && selectedTime != null) {
      final selectedDateTime = DateTime(
        selectedDate!.year,
        selectedDate!.month,
        selectedDate!.day,
        selectedTime!.hour,
        selectedTime!.minute,
      );

      final donationProvider = context.read<DonationProvider>();
      final userStorageProvider = context.read<UserStorageProvider>();

      if (others.isNotEmpty) {
        donatedItems.add(others);
      }

      Donation temp;

      if (pickUp) {
        temp = Donation(
          id: '',
          donatedItems: donatedItems,
          isPickup: pickUp,
          weight: weight,
          addressForPickup: addresses, // Include addresses for pickup
          donorId: widget.userId,
          recipientId: widget.companyId,
          status: status,
          contactNumber: contactNumber, // Include contact number
          selectedDateandTime: Timestamp.fromDate(selectedDateTime),
        );
      } else {
        temp = Donation(
          id: '',
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
      print(donationId);

      if (_image != null) {
        String url = await userStorageProvider.uploadSingleFile(
            _image!, "donations/$donationId");

        // Update url and donation id field

        Donation details = Donation(
            id: donationId,
            donatedItems: donatedItems,
            isPickup: pickUp,
            weight: weight,
            donorId: widget.userId,
            recipientId: widget.companyId,
            status: status,
            contactNumber: contactNumber, // Include contact number
            selectedDateandTime: Timestamp.fromDate(selectedDateTime),
            addressForPickup: addresses, // Include addresses for pickup
            url: url);

        await donationProvider.updateDonation(donationId, details).then((value) => Navigator.pop(context));
      }
    }
  } catch (error) {
    print("Error during donation sending: $error");
  }
}

AppBar _buildAppBar(BuildContext context, Text titleText) {
  return AppBar(
    centerTitle: true,
    title: titleText,
    leading: IconButton(
      icon: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Styles.mainBlue.withOpacity(0.1), // Circle background with some transparency
        ),
        child: Icon(
          Icons.arrow_back,
          color: Styles.mainBlue,
        ),
      ),
      onPressed: () {
        if (_isFormFilled()) {
          _showExitConfirmationDialog();
        } else {
          Navigator.of(context).pop();
        }
      },
    ),
    automaticallyImplyLeading: false,
  );
}

void _showExitConfirmationDialog() {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Are you sure?'),
        content: Text('All inputs will be deleted if you exit this screen.'),
        actions: <Widget>[
          TextButton(
            child: Text('No'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          TextButton(
            child: Text('Yes'),
            onPressed: () {
              Navigator.of(context).pop(); // Close the dialog
              Navigator.of(context).pop(); // Go back
            },
          ),
        ],
      );
    },
  );
}

Widget donationCheckbox() {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const Padding(
        padding: EdgeInsets.symmetric(vertical: 8.0),
        child: Text(
          'Select Donation Types:',
          style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
        ),
      ),
      CheckboxListTile(
        title: Row(
          children: [
            Icon(Icons.fastfood), // Add leading icon
            SizedBox(width: 10),
            Text('Food'),
          ],
        ),
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
        title: Row(
          children: [
            Icon(Icons.shopping_bag), // Add leading icon
            SizedBox(width: 10),
            Text('Clothes'),
          ],
        ),
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
        title: Row(
          children: [
            Icon(Icons.attach_money), // Add leading icon
            SizedBox(width: 10),
            Text('Cash'),
          ],
        ),
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
        title: Row(
          children: [
            Icon(Icons.shopping_cart), // Add leading icon
            SizedBox(width: 10),
            Text('Necessities'),
          ],
        ),
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
      CheckboxListTile(
        title: Row(
          children: [
            Icon(Icons.more_horiz), // Add leading icon
            SizedBox(width: 10),
            Expanded(
              child: TextFormField(
                onChanged: (value) {
                  setState(() {
                    others = value;
                  });
                },
                decoration: InputDecoration(
                  hintText: 'Other Donation',
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0), // Adjust size here
                ),
              ),
            ),
          ],
        ),
        value: others.isNotEmpty,
        onChanged: (newValue) {
          setState(() {
            if (newValue == true) {
              donatedItems.add(others);
            } else {
              donatedItems.remove(others);
              others = '';
            }
          });
        },
      ),
    ],
  );
}


Widget toggleSwitch() {
  return LayoutBuilder(
    builder: (BuildContext context, BoxConstraints constraints) {
      return Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Styles.gray, // Background color for the unselected state
        ),
        child: Stack(
          children: [
            AnimatedPositioned(
              duration: const Duration(milliseconds: 300), // Animation duration
              width: constraints.maxWidth / 2,
              top: 0,
              bottom: 0,
              left: pickUp ? 0 : constraints.maxWidth / 2,
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Styles.lightestBlue, Styles.mainBlue],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
            toggleText()
          ],
        ),
      );
    },
  );
}

  Widget toggleText() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          flex: 1,
          child: GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: () {
              setState(() {
                pickUp = true; // Update the state for "Pick Up"
              });
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Center(
                child: Text(
                  "Pick Up",
                  style: TextStyle(
                    color: pickUp ? Colors.white : Colors.blue,
                  ),
                ),
              ),
            ),
          ),
        ),
        Expanded(
          flex: 1,
          child: GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: () {
              setState(() {
                pickUp = false; // Update the state for "Drop Off"
              });
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Center(
                child: Text(
                  "Drop Off",
                  style: TextStyle(
                    color: pickUp ? Colors.blue : Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

}
