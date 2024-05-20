import 'dart:convert';

class AppUser {
  final String email;
  final String username;
  final String name;
  final String contactNo;
  final List<String> address;
  final int accountType;
  final bool isApproved;

  final bool isOpen;
  final String desc;

  AppUser({
    required this.email,
    required this.username,
    required this.name,
    required this.contactNo,
    required this.address,
    required this.accountType,
    required this.isApproved,

    // additional fields for organizations
    this.isOpen = true,
    this.desc = ''
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

      isOpen: json['isOpen'],
      desc: json['desc']
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

      'isOpen': isOpen,
      'desc': desc
    };
  }
}

enum accountType { donor, organization, admin }
