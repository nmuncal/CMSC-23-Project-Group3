import 'dart:convert';

class DonationDrive {
  final String id;
  final String name;
  final String organizationid;
  final String details;
  final bool status;
  final List<String> donations;
  final String photo;

  DonationDrive({
    required this.id,
    required this.name,
    required this.organizationid,
    required this.details,
    required this.status,
    required this.donations,
    this.photo = '',
  });

  factory DonationDrive.fromJson(Map<String, dynamic> json) {
    return DonationDrive(
      id :json['id'],
      name: json['name'],
      organizationid: json['organizationid'],
      details: json['details'],
      status: json['status'],
      photo: json['photo'],
      donations: List<String>.from(json['donations']),
    );
  }

  static List<DonationDrive> fromJsonArray(String jsonData) {
    final Iterable<dynamic> data = jsonDecode(jsonData);
    return data.map<DonationDrive>((dynamic d) => DonationDrive.fromJson(d)).toList();
  }

  Map<String, dynamic> toJson(DonationDrive donationDrive) {
    return {
      'id':id,
      'name': name,
      'organizationid': organizationid,
      'details': details,
      'status': status,
      'photo' :photo,
      'donations':donations
    };
  }
}
