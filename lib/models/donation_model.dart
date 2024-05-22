import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';

class Donation {
  final bool food;
  final bool clothes;
  final bool cash;
  final bool necessities;
  final bool isPickup;
  final String weight;
  final List<String> addressForPickup;
  final String recipientName;
  final String donorName;
  final String donorId;
  final String recipientId;
  final String status;
  final String contactNumber;
  final Timestamp selectedDateandTime;

  Donation({
    required this.food,
    required this.clothes,
    required this.cash,
    required this.necessities,
    required this.isPickup,
    required this.weight,
    required this.addressForPickup,
    required this.recipientName,
    required this.donorName,
    required this.donorId,
    required this.recipientId,
    required this.status,
    required this.contactNumber,
    required this.selectedDateandTime,
  });

  factory Donation.fromJson(Map<String, dynamic> json) {
    return Donation(
      food: json['food'],
      clothes: json['clothes'],
      cash: json['cash'],
      necessities: json['necessities'],
      isPickup: json['isPickup'],
      weight: json['weight'],
      addressForPickup: List<String>.from(json['addressForPickup']),
      recipientName: json['recipientName'],
      donorName: json['donorName'],
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
      'food': food,
      'clothes': clothes,
      'cash': cash,
      'necessities': necessities,
      'isPickup': isPickup,
      'weight': weight,
      'addressForPickup': addressForPickup,
      'recipientName': recipientName,
      'donorName': donorName,
      'donorId' : donorId, 
      'recipientId':  recipientId,
      'status': status,
      'contactNumber': contactNumber,
      'selectedDateandTime': selectedDateandTime,
    };
  }
}
