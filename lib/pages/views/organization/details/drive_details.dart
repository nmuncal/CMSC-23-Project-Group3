import 'package:flutter/material.dart';

class DriveDetailPage extends StatelessWidget {
  final String driveName;

  const DriveDetailPage({super.key, required this.driveName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(driveName),
      ),
      body: Center(
        child: Text('Details about $driveName'),
      ),
    );
  }
}
