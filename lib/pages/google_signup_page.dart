import 'dart:async';
import 'dart:io';
import 'package:cmsc_23_project_group3/models/user_model.dart';
import 'package:cmsc_23_project_group3/providers/auth_provider.dart';
import 'package:cmsc_23_project_group3/providers/storage_provider.dart';
import 'package:cmsc_23_project_group3/providers/user_provider.dart';
import 'package:cmsc_23_project_group3/styles.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:provider/provider.dart';

class GoogleSignupPage extends StatefulWidget {
  final String email;
  final String name;
  final String uid;

  const GoogleSignupPage(
      {super.key, required this.email, required this.name, required this.uid});

  @override
  State<GoogleSignupPage> createState() => _GoogleSignupPageState();
}

class _GoogleSignupPageState extends State<GoogleSignupPage> {
  final storageProvider = UserStorageProvider();
  final _formKey = GlobalKey<FormState>();
  late List<File> files = [];

  String? username;
  String? contactNo;
  String? address;
  String? secondaryAddress = '';

  int accountType = 0; // 0 - Donor, 1 - Organization, 2 - Admin
  bool secondaryAddressEnabled = false;
  bool _signUpPressed = false;
  bool errorSignup = false;
  String? errorSignupMessage;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          scrolledUnderElevation: 0,
          title: Text(
            "Save Your Information",
            style: TextStyle(
                color: Styles.mainBlue,
                fontSize: 25,
                fontWeight: FontWeight.bold),
          ),
          backgroundColor: Colors.white,
        ),
        body: signUpBody());
  }

  Widget signUpBody() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 15),
            registerType(),
            const SizedBox(height: 15),
            Text("Basic Information", style: TextStyle(color: Styles.mainBlue)),
            basicInformation(),
            const SizedBox(height: 15),
            Text("Contact Details", style: TextStyle(color: Styles.mainBlue)),
            contactDetails(),
            accountType == 1 ? proofOfLegitimacy() : Container(),
            const SizedBox(height: 20),
            signUpButton(),
            const SizedBox(height: 15),
            errorSignup
                ? Center(
                    child: Text(errorSignupMessage!,
                        style: TextStyle(color: Colors.red)))
                : Container(),
            const SizedBox(height: 15),
          ],
        ),
      ),
    );
  }

  Widget registerType() {
    return Column(
      children: [
        Text("What are you registering for?",
            style: TextStyle(color: Styles.mainBlue)),
        const SizedBox(height: 10),
        toggleSwitch()
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
                duration:
                    const Duration(milliseconds: 300), // Animation duration
                width: constraints.maxWidth / 2,
                top: 0,
                bottom: 0,
                left: accountType == 0 ? 0 : constraints.maxWidth / 2,
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
                accountType = 0; // Update the state for "Donor"
              });
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Center(
                child: Text("Donor",
                    style: TextStyle(
                        color:
                            accountType == 0 ? Colors.white : Styles.mainBlue)),
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
                accountType = 1; // Update the state for "Organization"
              });
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Center(
                child: Text("Organization",
                    style: TextStyle(
                        color:
                            accountType == 1 ? Colors.white : Styles.mainBlue)),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget basicInformation() {
    return Column(
      children: [
        const SizedBox(height: 10),
        usernameField(),
        const SizedBox(height: 10),
      ],
    );
  }

  Widget usernameField() {
    return TextFormField(
      decoration:
          Styles.textFieldStyle('Username'), // Use the builder from styles.dart
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter your username';
        }
        return null;
      },
      onSaved: (value) {
        username = value!;
      },
    );
  }

  Widget contactDetails() {
    return Column(
      children: [
        const SizedBox(height: 10),
        contactNoField(),
        const SizedBox(height: 10),
        addressField(),
        const SizedBox(height: 10),
        secondaryAddressEnabled
            ? secondaryAddressField()
            : addSecondaryAddressButton(),
      ],
    );
  }

  Widget contactNoField() {
    return TextFormField(
      decoration: Styles.textFieldStyle('Contact No.'),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter your contact number';
        }
        return null;
      },
      onSaved: (value) {
        contactNo = value!;
      },
    );
  }

  Widget addressField() {
    return TextFormField(
      decoration: Styles.textFieldStyle('Main Address'),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter your address';
        }
        return null;
      },
      onSaved: (value) {
        address = value!;
      },
    );
  }

  Widget secondaryAddressField() {
    return TextFormField(
      decoration: Styles.textFieldStyle('Secondary Address').copyWith(
        suffixIcon: IconButton(
          icon: Icon(Icons.remove_circle_outline, color: Styles.darkerGray),
          onPressed: () {
            // Hiding and showing password
            setState(() {
              secondaryAddressEnabled = false;
            });
          },
        ),
      ),
      onSaved: (value) {
        secondaryAddress = value!;
      },
    );
  }

  Widget addSecondaryAddressButton() {
    return GestureDetector(
      child: Styles.iconButtonBuilder(
          null, Icon(Icons.add, color: Styles.mainBlue), Styles.mainBlue, null),
      onTap: () {
        setState(() {
          secondaryAddressEnabled = true;
        });
      },
    );
  }

  Widget proofOfLegitimacy() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 15),
        Text("Proof/s of Legitimacy", style: TextStyle(color: Styles.mainBlue)),
        const SizedBox(height: 10),
        addProof()
      ],
    );
  }

  Widget addProof() {
    return Column(
      children: [
        for (int i = 0; i < files.length; i++)
          Row(
            children: [
              Expanded(
                child: Text(files[i].path.split('/').last),
              ),
              IconButton(
                icon: Icon(Icons.delete),
                onPressed: () {
                  setState(() {
                    files.removeAt(i);
                  });
                },
              ),
            ],
          ),
        GestureDetector(
          child: Styles.iconButtonBuilder(
              null,
              Icon(Icons.arrow_upward_rounded, color: Styles.mainBlue),
              Styles.mainBlue,
              null),
          onTap: () async {
            final filesResult = await FilePicker.platform.pickFiles(
              allowMultiple: true,
            );
            if (filesResult != null && filesResult.files.isNotEmpty) {
              for (var file in filesResult.files) {
                String fileName = file.path!.split('/').last;
                // Check if the file name already exists in the list
                bool fileExists = files.any((existingFile) =>
                    existingFile.path.split('/').last == fileName);
                if (!fileExists) {
                  // If the file is not present, add it to the list
                  files.add(File(file.path!));
                }
              }
              setState(() {});
            }
          },
        ),
      ],
    );
  }

  Widget signUpButton() {
    return GestureDetector(
      child:
          Styles.gradientButtonBuilder('Save Info', isPressed: _signUpPressed),
      onTap: () async {
        if (_formKey.currentState!.validate()) {
          _formKey.currentState!.save();
          setState(() {
            _signUpPressed = true;
          });
          await _handleSignUp();
          setState(() {
            _signUpPressed = false;
          });
        }
      },
    );
  }

  Future<void> _handleSignUp() async {
    try {
      final userAuthProvider = context.read<UserAuthProvider>();
      final userProvider = context.read<UserProvider>();
      final userStorageProvider = context.read<UserStorageProvider>();

      bool isUsernameUnique =
          await userAuthProvider.isUsernameUnique(username!);
      print(isUsernameUnique);

      if (isUsernameUnique) {
        if (accountType == 1 && files.isNotEmpty) {
          List<String> urls = await userStorageProvider.uploadMultipleFiles(
              files, "users/${widget.uid}/proofOfLegitimacy");

          AppUser userDetails = AppUser(
              email: widget.email,
              uid: widget.uid,
              username: username!,
              name: widget.name,
              contactNo: contactNo!,
              address: secondaryAddress!.isEmpty
                  ? [address!]
                  : [address!, secondaryAddress!],
              accountType: accountType,
              isApproved: false,
              proofOfLegitimacy: urls);

          await userProvider.addUser(widget.uid,userDetails).then((value) => Navigator.pop(context)
          );
        } else {
          AppUser userDetails = AppUser(
            email: widget.email,
            uid: widget.uid,
            username: username!,
            name: widget.name,
            contactNo: contactNo!,
            address: secondaryAddress!.isEmpty
                ? [address!]
                : [address!, secondaryAddress!],
            accountType: accountType,
            isApproved: false,
          );
          await userProvider.addUser(widget.uid,userDetails).then((value) => Navigator.pop(context));

        }
      } else {
        setState(() {
          errorSignup = true;
          errorSignupMessage = "Username already exists!";
        });
      }
    } catch (error) {
      print("Error during sign up: $error");
    }
  }
}
