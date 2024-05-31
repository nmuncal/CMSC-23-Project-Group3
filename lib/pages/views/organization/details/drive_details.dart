import 'package:flutter/material.dart';

class DriveDetailPage extends StatefulWidget {
  final String driveId;
  final bool? isOrg;

  const DriveDetailPage({super.key, required this.driveId, this.isOrg});

  @override
  State<DriveDetailPage> createState() => _DriveDetailPageState();
}

class _DriveDetailPageState extends State<DriveDetailPage> {


  // IF isOrg show routing of donations

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.driveId),
      ),
      body: Center(
        child: Text('Details about ${widget.driveId}'),
      ),
    );
  }
}
