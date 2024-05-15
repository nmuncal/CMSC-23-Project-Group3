import 'package:flutter/material.dart';

class PendingDetailPage extends StatelessWidget {
  final String signupName;

  const PendingDetailPage({super.key, required this.signupName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(signupName),
      ),
      body: Center(
        child: Text('Details about $signupName'),
      ),
    );
  }
}