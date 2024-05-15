import 'package:flutter/material.dart';
import 'details/signup_details.dart';

class AdminPending extends StatefulWidget {
  const AdminPending({super.key});

  @override
  State<AdminPending> createState() => _AdminPendingState();
}

class _AdminPendingState extends State<AdminPending> {
  // Define a list of pending signups
  final List<String> pendingSignups = [
    'Signup 1',
    'Signup 2',
    'Signup 3',
    'Signup 4',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pending Signups'),
      ),
      body: ListView.builder(
        itemCount: pendingSignups.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(pendingSignups[index]),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PendingDetailPage(signupName: pendingSignups[index]),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
