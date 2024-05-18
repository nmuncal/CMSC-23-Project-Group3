import 'dart:async';
import 'dart:io';
import 'package:cmsc_23_project_group3/providers/auth_provider.dart';
import 'package:cmsc_23_project_group3/providers/storage_provider.dart';
import 'package:cmsc_23_project_group3/styles.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:provider/provider.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final storageProvider = UserStorageProvider();
  final _formKey = GlobalKey<FormState>();
  late List<File> files = [];

  String? email;
  String? password;
  String? username;
  String? name;
  String? contactNo;
  String? address;
  String? secondaryAddress;

  int accountType = 0; // 0 - Donor, 1 - Organization, 2 - Admin
  bool _obscureText = true;
  bool secondaryAddressEnabled = false;
  bool _signUpPressed = false;

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
            "Join Now",
            style: TextStyle(
                color: Styles.mainBlue,
                fontSize: 36,
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
        emailField(),
        const SizedBox(height: 10),
        nameField(),
        const SizedBox(height: 10),
        usernameField(),
        const SizedBox(height: 10),
        passwordField(),
        const SizedBox(height: 10),
      ],
    );
  }

  Widget emailField() {
    return TextFormField(
      decoration:
          Styles.textFieldStyle('Email'), // Use the builder from styles.dart
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter your email';
        }
        return null;
      },
      onSaved: (value) {
        email = value!;
      },
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

  Widget passwordField() {
    return TextFormField(
      obscureText: _obscureText,
      decoration: Styles.textFieldStyle('Password').copyWith(
        suffixIcon: IconButton(
          icon: Icon(
            _obscureText
                ? Icons.visibility_outlined
                : Icons.visibility_off_outlined,
            color: Styles.darkerGray,
          ),
          onPressed: () {
            // Hiding and showing password
            setState(() {
              _obscureText = !_obscureText;
            });
            _autohideTimer();
          },
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter your password';
        }
        return null;
      },
      onSaved: (value) {
        password = value!;
      },
    );
  }

  void _autohideTimer() {
    Timer(const Duration(seconds: 5), () {
      setState(() {
        _obscureText = true; // Hide the password after 5 seconds
      });
    });
  }

  Widget nameField() {
    return TextFormField(
      decoration: Styles.textFieldStyle(accountType == 0
          ? 'Name'
          : 'Name of Organization'), // Use the builder from styles.dart
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter your name';
        }
        return null;
      },
      onSaved: (value) {
        name = value!;
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
          null, Icon(Icons.add, color: Styles.mainBlue), Styles.mainBlue),
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
    return GestureDetector(
      child: Styles.iconButtonBuilder(
          null,
          Icon(Icons.arrow_upward_rounded, color: Styles.mainBlue),
          Styles.mainBlue),
      onTap: () async {
        final filesResult = await FilePicker.platform.pickFiles(
          allowMultiple: true,
        );
        if (filesResult != null && filesResult.files.isNotEmpty) {
          files = filesResult.files.map((file) => File(file.path!)).toList();
          setState(() {});
        }
      },
    );
  }

  Widget signUpButton() {
    return GestureDetector(
      child: Styles.gradientButtonBuilder('Sign Up', isPressed: _signUpPressed),
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
    final userStorageProvider = context.read<UserStorageProvider>();

    // Attempt sign-up
    String? uid = await userAuthProvider.signUp(
      email!,
      password!,
      username!,
      name!,
      contactNo!,
      secondaryAddress!.isEmpty ? [address!] : [address!, secondaryAddress!],
      accountType,
      false,
    );

    // Check if UID is not null and not an error message
    if (uid != null && !uid.contains("Error")) {
      // Proceed with file upload only if the account type is 1 and files are not empty
      if (accountType == 1 && files.isNotEmpty) {
        await userStorageProvider.uploadMultipleFiles(files, "$uid/proofOfLegitimacy");
      }

      // If all operations were successful, navigate back
      if (mounted) {
        Navigator.pop(context);
      }
    } else {
      // Handle sign-up failure or error message (e.g., display an error message to the user)
      print("Sign-up failed: $uid");
      // Optionally, you can show an error message to the user
      // You can use a SnackBar or showDialog to display an error message
    }
  } catch (error) {
    // Handle any errors that occur during sign up
    print("Error during sign up: $error");
    // Optionally, you can show an error message to the user
    // You can use a SnackBar or showDialog to display an error message
  }
}

}
