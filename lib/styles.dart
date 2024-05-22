// This class contains the color palette and other styling components of the app
// Also contains reusable builder/styles for common components 
// (Styling for TextFormFields, Gradient Button, Icon Button)


import 'package:flutter/material.dart';

class Styles{
  static Color mainBlue = const Color(0xFF405F7D);
  static Color lightestBlue = const Color(0xFF86AACD);

  static Color gray = const Color(0xFFF4F4F4);
  static Color darkerGray = const Color(0xFFAFAFAF);
  
  static BorderRadius rounded = BorderRadius.circular(20);
  

  static InputDecoration textFieldStyle (hintText) => InputDecoration(    // Style for text form field 
      hintText: hintText,
      hintStyle: TextStyle(color: darkerGray),
      filled: true,
      fillColor: gray,
      contentPadding: const EdgeInsets.symmetric(vertical: 20, horizontal: 15), 
      
      border: OutlineInputBorder(
        borderRadius: rounded,
        borderSide: BorderSide.none
      ),

      focusedBorder: OutlineInputBorder(
        borderRadius: rounded,
        borderSide: BorderSide(color: mainBlue, width: 1),
      ),
  );

  static Widget gradientButtonBuilder(String buttonText, {bool isPressed = false}) {    // Makes a gradient button
    return AnimatedContainer(
      alignment: Alignment.center,
      duration: const Duration(milliseconds: 1000),
      height: 60,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: isPressed
            ? LinearGradient(
                colors: [mainBlue, lightestBlue], 
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              )
            : LinearGradient(
                colors: [lightestBlue, mainBlue],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
      ),
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 15),
      child: isPressed
          ? const SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                strokeWidth: 2.0,
              ),
            )
          : SizedBox(
              height: 20,
              child: Text(
                buttonText,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16
                ),
              ),
            )
          
          
    );
  }

  static Widget iconButtonBuilder(
    String? imagePath,
    Icon? icon, 
    Color? color,
    {bool isPressed = false,
  }) {
    return AnimatedContainer(
      alignment: Alignment.center,
      duration: const Duration(milliseconds: 1000),
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color ?? Styles.mainBlue, width: 1),
        color: Colors.white,
      ),
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 15),
      child: isPressed
          ? SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(color ?? Styles.mainBlue),
                strokeWidth: 2.0,
              ),
            )
          : (imagePath != null
              ? Image.asset(
                  imagePath,
                  height: 20,
                )
              : icon),
    );
  }
  
}