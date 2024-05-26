import 'package:url_launcher/url_launcher.dart';

import 'package:cmsc_23_project_group3/models/user_model.dart';
import 'package:cmsc_23_project_group3/providers/user_provider.dart';
import 'package:cmsc_23_project_group3/styles.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher_string.dart';

class OrgProof extends StatefulWidget {
  final String orgId;
  const OrgProof({super.key, required this.orgId});

  @override
  State<OrgProof> createState() => _OrgProofState();
}

class _OrgProofState extends State<OrgProof> {

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<UserProvider>().getAccountInfo(null);
      context.read<UserProvider>().getAccountInfo(widget.orgId);
    });
  }

  AppUser? org;

  @override
  Widget build(BuildContext context) {

    org = context.watch<UserProvider>().selectedUser;

    return org == null ? 
    const Center(child: CircularProgressIndicator()) :
    Scaffold(
        appBar: AppBar(
          scrolledUnderElevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
            color: Styles.mainBlue,
          ),
          title: Text(
            org!.name,
            style: TextStyle(
                color: Styles.mainBlue,
                fontSize: 36,
                fontWeight: FontWeight.bold),
          ),
          backgroundColor: Colors.white,
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: body(org!.proofOfLegitimacy),
        )
      );
  }

  String getFileName(String url) {
    Uri uri = Uri.parse(url);
    String fileName = uri.pathSegments.last.split("/").last;
    return fileName;
  }

  Widget body(List<String> proofs) {
    if (proofs.isEmpty) {
      return const Center(
        child: Text("No Files Found!"),
      );
    } else {
      return ListView.builder(
        itemCount: proofs.length,
        itemBuilder: (context, index) {
          String fileName = getFileName(proofs[index]);

          IconData iconData;
          if (fileName.endsWith(".jpg") || fileName.endsWith(".jpeg")) {
            iconData = Icons.image;
          } else if (fileName.endsWith(".pdf")) {
            iconData = Icons.picture_as_pdf;
          } else {
            iconData = Icons.insert_drive_file;
          }

          return ListTile(
            leading: Icon(iconData),
            title: Text(fileName),
            onTap: () => _launchURL(proofs[index]),
          );
          },
          );
        }
    }

    Future<void> _launchURL(String url) async {
    if (await canLaunchUrlString(url)) {
      print(url);
      await launchUrlString(
        url
      );
    } else {
      throw 'Could not launch $url';
    }
  }
}