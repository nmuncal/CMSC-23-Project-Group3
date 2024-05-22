import 'package:cmsc_23_project_group3/api/firebase_donation_api.dart';
import 'package:flutter/material.dart';
import '../models/donation_model.dart';

class DonationProvider with ChangeNotifier {
  FirebaseDonationAPI firebaseService = FirebaseDonationAPI();
  late Stream<List<Donation>> _donationStream = Stream.empty();

  Stream<List<Donation>> get donationStream => _donationStream;

  void fetchDonations(String uid) {
    try {
      _donationStream = firebaseService.fetchDonations(uid);
      notifyListeners();
    } catch (e) {
      print('Error fetching users: $e');
      _donationStream = Stream.empty();
      notifyListeners();
    }
  }

  Future<String> addDonation(
      Donation donation, String userId, String recipientId) async {
    String message = await firebaseService.addDonation(
        donation.toJson(donation), userId, recipientId);
    notifyListeners();
    return message;
  }
}
