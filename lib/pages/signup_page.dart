import 'dart:async';

import 'package:cmsc_23_project_group3/styles.dart';
import 'package:flutter/material.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      body: signUpBody() 
    );
  }

  int accountType = 0;  //  0 - Donor, 1 - Organization, 2 - Admin

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
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
          fontWeight: FontWeight.bold,
        ),
      ),
      backgroundColor: Colors.white,
    );
  }

  Widget signUpBody(){
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 30),
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
      )
    );
  }

  Widget registerType(){
    return Column(
      children: [
        Text("What are you registering for?", style: TextStyle(color: Styles.mainBlue)),
        const SizedBox(height: 10),
        toggleSwitch()          
      ],
    );
  }

  Widget toggleSwitch() {
    return LayoutBuilder( // Use LayoutBuilder to get parent container size
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
                top:0,
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
      }
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
              child:Center(
              child: Text(
                "Donor",
                style: TextStyle(
                  color: accountType == 0 ? Colors.white : Styles.mainBlue
                )
                
              ),
            )),
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
              child:Center(
              child: Text(
                "Organization",
                style: TextStyle(
                  color: accountType == 1 ? Colors.white : Styles.mainBlue
                )
                
              ),
            )),
          ),
        ),
      ],
    );
  }

  Widget basicInformation(){
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
      decoration: Styles.textFieldStyle('Email'),   // Use the builder from styles.dart
    );
  }

  Widget usernameField() {
    return TextFormField(
      decoration: Styles.textFieldStyle('Username'),   // Use the builder from styles.dart
    );
  }

  bool _obscureText = true;

  Widget passwordField() {
    return TextFormField(
      obscureText: _obscureText,
      decoration: Styles.textFieldStyle('Password').copyWith(  
        suffixIcon: IconButton(
          icon: Icon(
            _obscureText ? Icons.visibility_outlined : Icons.visibility_off_outlined,
            color: Styles.darkerGray,
          ),
          onPressed: () {       // Hiding and showing password
            setState(() {
              _obscureText = !_obscureText;
            });
            _autohideTimer();
          },
        ),
      ),
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
      decoration: Styles.textFieldStyle(accountType == 0 ? 'Name': 'Name of Organization'),   // Use the builder from styles.dart
    );
  }

  bool secondaryAddressEnabled = false;
  Widget contactDetails(){
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
      decoration: Styles.textFieldStyle('Contact No.'),   // Use the builder from styles.dart
    );
  }

  Widget addressField() {
    return TextFormField(
      decoration: Styles.textFieldStyle('Main Address'),   // Use the builder from styles.dart
    );
  }

  Widget secondaryAddressField() {
    return TextFormField(
      decoration: Styles.textFieldStyle('Secondary Address').copyWith(  
        suffixIcon: IconButton(
          icon: Icon(Icons.remove_circle_outline, color: Styles.darkerGray),
          onPressed: () {       // Hiding and showing password
            setState(() {
              secondaryAddressEnabled = false;
            });
          },
        ),
      ),
    );
  }

 
  Widget addSecondaryAddressButton() {
    return GestureDetector(
      child: Styles.iconButtonBuilder(
        null, 
        Icon(Icons.add, color: Styles.mainBlue), 
        Styles.mainBlue
      ),
      onTap: () {
        setState(() {
          secondaryAddressEnabled = true;
        });
      }
    );
  }

  Widget proofOfLegitimacy(){
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
        Styles.mainBlue
      ),
      onTap: () {
        setState(() {

        });
      }
    );
  }

  bool _signUpPressed = false;
  Widget signUpButton() {
    return GestureDetector(
      child: Styles.gradientButtonBuilder('Sign Up', isPressed: _signUpPressed),  // Use gradientButtonBuilder from styles.dart
      onTap: () {
        setState(() {
          _signUpPressed = true;
        });

        // SIGN UP LOGIC

      }
    );
  }
}
