import 'package:flutter/material.dart';

class Styles{
  static Color gray = const Color(0xFFF4F4F4);
  static Color mainBlue = const Color(0xFF405F7D);
  static Color darkerGray = const Color(0xFFAFAFAF);
  static Color lightestBlue = const Color(0xFF86AACD);
  static BorderRadius rounded = BorderRadius.circular(20);
  

  static InputDecoration textFieldStyle (hintText) => InputDecoration(
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

  static Widget gradientButtonBuilder(String buttonText, {bool isPressed = false}) {
    return AnimatedContainer(
      alignment: Alignment.center,
      duration: const Duration(milliseconds: 1000),
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: isPressed
            ? LinearGradient(
                colors: [mainBlue, lightestBlue], // Swap colors for animation
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

  static Widget iconButtonBuilder(String imagePath, {bool isPressed = false}) {
    return AnimatedContainer(
      alignment: Alignment.center,
      duration: const Duration(milliseconds: 1000),
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: gray
      ),
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 15),
      child: isPressed
          ? SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(darkerGray),
                strokeWidth: 2.0,
              ),
            )
          : SizedBox(
            height: 20,
            child: Image.asset(imagePath)
          )
    );
  }
  
}