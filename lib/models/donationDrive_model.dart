import 'dart:convert';
import 'package:cmsc_23_project_group3/models/donation_model.dart';

class DonationDrive {
  final String name;
  final String organization;
  final String details;
  final bool status;
  final List<String> donations;


  DonationDrive({
    required this.name,
    required this.organization,
    required this.details,
    required this.status,
    required this.donations,
  });

  factory DonationDrive.fromJson(Map<String, dynamic> json) {
    return DonationDrive(
      name: json['name'],
      organization: json['organization'],
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
      'organization': organization,
      'details': details,
      'status': status,
      'donations':donations
     
    };
  }
}
