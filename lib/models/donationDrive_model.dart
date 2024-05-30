import 'dart:convert';

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

  Map<String, dynamic> toJson(DonationDrive donationDrive) {
    return {
      'name': name,
      'organizationid': organizationid,
      'details': details,
      'status': status,
      'donations':donations
    };
  }
}
