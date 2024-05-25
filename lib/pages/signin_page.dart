import 'dart:async';
import 'package:cmsc_23_project_group3/pages/signup_page.dart';
import 'package:cmsc_23_project_group3/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:cmsc_23_project_group3/styles.dart';
import 'package:provider/provider.dart'; // Uses the styles class to make reusable widgets/components

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  String? email;
  String? password;
  String? errorMessage;

  bool errorSignIn = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        // Places them in a stack so that the white container sits on top of the background image
        children: [
          bgImg,
          Align(
            alignment: Alignment.bottomCenter,
            child: authFormField,
          ),
        ],
      ),
    );
  }

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Widget get bgImg => Container(
        // Background image on the top of the screen
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('lib/assets/bg_login.png'),
            fit: BoxFit.cover,
          ),
        ),
      );

  Widget get authFormField => SingleChildScrollView(
        // White rounded rectangle where the fields are placed
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              alignment: Alignment.center,
              height: MediaQuery.of(context).size.height * 0.75,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(50),
                  topRight: Radius.circular(50),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.10),
                    spreadRadius: 10,
                    blurRadius: 15,
                    offset: const Offset(0, 5),
                  )
                ],
              ),
              child: signInField(), // Contains the Sign In fields
            ),
          ],
        ),
      );

  Widget signInField() {
    return Form(
        // SIGN IN FORM
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Logo area
            SizedBox(
                height: 175, child: Image.asset('lib/assets/ico_logo.png')),
            const SizedBox(height: 15),

            // Textfields/Buttons
            emailField(),
            const SizedBox(height: 15),
            passwordField(),
            const SizedBox(height: 15),

            signInButton(),
            const SizedBox(height: 15),
            errorSignIn
                ? Center(child: Text(errorMessage!, style: TextStyle(color: Colors.red)))
                : Container(),
            const SizedBox(height: 15),

            // Google SignIn area, and Sign Up
            //googleSignInButton(),
            //const SizedBox(height: 15),

            textToSignUp()
          ],
        ));
  }

  Widget emailField() {
    return TextFormField(
      decoration: Styles.textFieldStyle('Email'),
      onSaved: (value) => setState(() => email = value),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return "Please enter your email";
        }
        return null;
      }, // Use the builder from styles.dart
    );
  }

  bool _obscureText = true;

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
      onSaved: (value) => setState(() => password = value),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return "Please enter your password";
        }
        return null;
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

  // Indicates whether buttons should show a circular loading
  bool _signInPressed = false;
  bool _googleSignInPressed = false;

  void resetSignInLoading() {
    // Turns back button to initial state (non-loading)
    setState(() {
      _signInPressed = false;
      _googleSignInPressed = false;
    });
  }

  Widget signInButton() {
    return GestureDetector(
      child: Styles.gradientButtonBuilder('Sign In',
          isPressed:
              _signInPressed), // Use gradientButtonBuilder from styles.dart
      onTap: () async {
        if (_formKey.currentState!.validate()) {
          setState(() {
            _googleSignInPressed =
                false; // After pressing, sign in button shows a circular loading indicator
            _signInPressed = true;
          });

          _formKey.currentState!.save();
          String? message = await context
              .read<UserAuthProvider>()
              .authService
              .signIn(email!, password!);

          if (message != "Successful!") {
            setState(() {
              resetSignInLoading();
              errorMessage = message;
              errorSignIn = true;
            });
          }
          print(message);
        }
      },

      // SIGN IN LOGIC
    );
  }

  Widget googleSignInButton() {
    return GestureDetector(
        child: Styles.iconButtonBuilder(
            'lib/assets/ico_google.png', null, Styles.mainBlue, null,
            isPressed: _googleSignInPressed),
        onTap: () {
          setState(() {
            _signInPressed =
                false; // After pressing, google button shows a circular loading indicator
            _googleSignInPressed = true;
          });

          // Google SIGN IN LOGIC
        });
  }

  Widget textToSignUp() {
    return TextButton(
      child: Text(
        "Dont have an account?",
        style: TextStyle(color: Styles.mainBlue),
      ),
      onPressed: () {
        resetSignInLoading();

        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const SignUpPage()));
      },
    );
  }
}
