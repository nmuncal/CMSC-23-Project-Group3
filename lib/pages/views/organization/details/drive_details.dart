import 'package:flutter/material.dart';

class DriveDetailPage extends StatelessWidget {
  final String driveId;

  const DriveDetailPage({super.key, required this.driveId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(driveId),
      ),
      body: Center(
        child: Text('Details about $driveId'),
      ),
    );
  }
}
