import 'dart:convert';
import 'package:cmsc_23_project_group3/models/donation_model.dart';

class DonationDrive {
  final String name;
  final String organizationid;
  final String details;
  final bool status;
  final List<String> donations;

  DonationDrive({
    required this.name,
    required this.organizationid,
    required this.details,
    required this.status,
    required this.donations,
  });

  factory DonationDrive.fromJson(Map<String, dynamic> json) {
    return DonationDrive(
      name: json['name'],
      organizationid: json['organizationid'],
      details: json['details'],
      status: json['status'],
      donations: List<String>.from(json['donations']),
    );
  }

  static List<DonationDrive> fromJsonArray(String jsonData) {
    final Iterable<dynamic> data = jsonDecode(jsonData);
    return data.map<DonationDrive>((dynamic d) => DonationDrive.fromJson(d)).toList();
  }

  Map<String, dynamic> toJson(Donation donation) {
    return {
      'name': name,
      'organizationid': organizationid,
      'details': details,
      'status': status,
      'donations':donations
    };
  }
}
