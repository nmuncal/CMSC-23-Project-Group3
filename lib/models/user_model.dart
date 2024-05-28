import 'dart:convert';

class AppUser {
  final String email;
  final String uid;
  final String username;
  final String name;
  final String contactNo;
  final List<String> address;
  final int accountType;
  final bool isApproved;

  final bool isOpen;
  final String desc;
  final List<String> proofOfLegitimacy;

  final String profilePhoto;
  final String coverPhoto;

  AppUser({
    required this.email,
    required this.uid,
    required this.username,
    required this.name,
    required this.contactNo,
    required this.address,
    required this.accountType,
    required this.isApproved,

    // additional fields for organizations
    this.isOpen = false,
    this.desc = '',
    this.proofOfLegitimacy = const [],

    //photo
    this.profilePhoto = '',
    this.coverPhoto = '',



  });

   AppUser copyWith({
    String? email,
    String? uid,
    String? username,
    String? name,
    String? contactNo,
    List<String>? address,
    int? accountType,
    bool? isApproved,
    bool? isOpen,
    String? desc,
    List<String>? proofOfLegitimacy,
    String? profilePhoto,
    String? coverPhoto,
  }) {
    return AppUser(
      email: email ?? this.email,
      uid: uid ?? this.uid,
      username: username ?? this.username,
      name: name ?? this.name,
      contactNo: contactNo ?? this.contactNo,
      address: address ?? this.address,
      accountType: accountType ?? this.accountType,
      isApproved: isApproved ?? this.isApproved,
      isOpen: isOpen ?? this.isOpen,
      desc: desc ?? this.desc,
      proofOfLegitimacy: proofOfLegitimacy ?? this.proofOfLegitimacy,
      profilePhoto: profilePhoto ?? this.profilePhoto,
      coverPhoto: coverPhoto ?? this.coverPhoto
    );
  }

  factory AppUser.fromJson(Map<String, dynamic> json) {
  return AppUser(
    email: json['email'] ?? '',
    uid: json['uid'] ?? '',
    username: json['username'] ?? '',
    name: json['name'] ?? '',
    contactNo: json['contactNo'] ?? '',
    address: List<String>.from(json['address'] ?? []),
    accountType: json['accountType'] ?? 0,
    isApproved: json['isApproved'] ?? false,
    isOpen: json['isOpen'] ?? false,
    desc: json['desc'] ?? '',
    proofOfLegitimacy: List<String>.from(json['proofOfLegitimacy'] ?? []),
    profilePhoto: json['profilePhoto'],
    coverPhoto: json['coverPhoto'],
  );
}

  static List<AppUser> fromJsonArray(String jsonData) {
    final Iterable<dynamic> data = jsonDecode(jsonData);
    return data.map<AppUser>((dynamic d) => AppUser.fromJson(d)).toList();
  }

  Map<String, dynamic> toJson(AppUser appUser) {
    return {
      'email': email,
      'uid': uid,
      'username': username,
      'name': name,
      'contactNo': contactNo,
      'address': address,
      'accountType': accountType,
      'isApproved': isApproved,
      'isOpen': isOpen,
      'desc': desc,
      'proofOfLegitimacy':proofOfLegitimacy,
      'profilePhoto':profilePhoto,
      'coverPhoto' :coverPhoto
    };
  }
}

