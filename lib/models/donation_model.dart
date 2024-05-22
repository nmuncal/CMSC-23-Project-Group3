import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';

class Donation {
  final List<String> donatedItems;
  final bool isPickup;
  final String weight;
  final List<String> addressForPickup;
  final String donorId;
  final String recipientId;
  final String status;
  final String contactNumber;
  final Timestamp selectedDateandTime;

  Donation({
    required this.donatedItems,
    required this.isPickup,
    required this.weight,
    required this.addressForPickup,
    required this.donorId,
    required this.recipientId,
    required this.status,
    required this.contactNumber,
    required this.selectedDateandTime,
  });

  factory Donation.fromJson(Map<String, dynamic> json) {
    return Donation(
      donatedItems: List<String>.from(json['donatedItems']),
      isPickup: json['isPickup'],
      weight: json['weight'],
      addressForPickup: List<String>.from(json['addressForPickup']),
      donorId: json['donorId'],
      recipientId: json['recipientId'],
      status: json['status'],
      contactNumber: json['contactNumber'],
      selectedDateandTime: json['selectedDateandTime'] ?? Timestamp.now(),
    );
  }

  static List<Donation> fromJsonArray(String jsonData) {
    final Iterable<dynamic> data = jsonDecode(jsonData);
    return data.map<Donation>((dynamic d) => Donation.fromJson(d)).toList();
  }

  Map<String, dynamic> toJson(Donation donation) {
    return {
      'donatedItems': donatedItems,
      'isPickup': isPickup,
      'weight': weight,
      'addressForPickup': addressForPickup,
      'donorId' : donorId, 
      'recipientId':  recipientId,
      'status': status,
      'contactNumber': contactNumber,
      'selectedDateandTime': selectedDateandTime,
    };
  }
}
