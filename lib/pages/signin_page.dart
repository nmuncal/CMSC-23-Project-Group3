import 'package:flutter/material.dart';
import 'package:cmsc_23_project_group3/styles.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('lib/assets/bg_login.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    alignment: Alignment.center,
                    height: MediaQuery.of(context).size.height * 0.75, // Adjust the height as needed
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(50),
                        topRight: Radius.circular(50),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.10), // Fixed opacity usage
                          spreadRadius: 10,
                          blurRadius: 15,
                          offset: const Offset(0, 5), // Vertical shadow position
                        )
                      ],
                    ),
                    child: signInField(), // Updated method name to follow Dart naming conventions
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }


  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Widget signInField() {
    return Form(
      key: _formKey, 
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [

          SizedBox(
            height: 75,
            child: Image.asset('lib/assets/logo.png')
          ),
          

          const SizedBox(height: 50),

          emailField(),

          const SizedBox(height: 15),
          
          passwordField(),

          const SizedBox(height: 15),

          signInButton(),

          const SizedBox(height: 15),

          googleSignInButton(),

          const SizedBox(height: 15),

          textToSignUp()
        ],
      )
    );
  }

  Widget emailField() {
    return TextFormField(
      decoration: Styles.textFieldStyle('Email'),
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
          onPressed: () {
            setState(() {
              _obscureText = !_obscureText;
            });
          },
        ),
      ),
    );
  }


  bool _signInPressed = false;
  bool _googleSignInPressed = false;

  void resetSignInLoading() {
    setState(() {
          _signInPressed = false;
          _googleSignInPressed = false;
    });
  }  
  
  Widget signInButton() {
    return GestureDetector(
      child: Styles.gradientButtonBuilder('Sign In', isPressed: _signInPressed),
      onTap: () {
        setState(() {
          _googleSignInPressed = false;
          _signInPressed = true;
        });

        // SIGN IN LOGIC

      }
    );
  }
  
  Widget googleSignInButton() {
    return GestureDetector(
      child: Styles.iconButtonBuilder('lib/assets/ico_google.png', isPressed: _googleSignInPressed),
      onTap: () {
        setState(() {
          _signInPressed = false;
          _googleSignInPressed = true;
        });

        // Google SIGN IN LOGIC

      }
    );
  }

  Widget textToSignUp() {
    return TextButton(
      child: Text("Dont have an account?", style: TextStyle(color: Styles.mainBlue),),
      onPressed: () {
        resetSignInLoading();

        // Push Sign Up Page

      },  
    );
  }

}
