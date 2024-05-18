import 'dart:convert';

class AppUser {
  final String email;
  final String username;
  final String name;
  final String contactNo;
  final List<String> address;
  final int accountType;
  final bool isApproved;

  AppUser({
    required this.email,
    required this.username,
    required this.name,
    required this.contactNo,
    required this.address,
    required this.accountType,
    required this.isApproved,
  });

  factory AppUser.fromJson(Map<String, dynamic> json) {
    return AppUser(
      email: json['email'],
      username: json['username'],
      name: json['name'],
      contactNo: json['contactNo'],
      address: List<String>.from(json['address']),
      accountType: json['accountType'],
      isApproved: json['isApproved'],
    );
  }

  static List<AppUser> fromJsonArray(String jsonData) {
    final Iterable<dynamic> data = jsonDecode(jsonData);
    return data.map<AppUser>((dynamic d) => AppUser.fromJson(d)).toList();
  }

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'username': username,
      'name': name,
      'contactNo': contactNo,
      'address': address,
      'accountType': accountType,
      'isApproved': isApproved,
    };
  }
}

enum accountType { donor, organization }
