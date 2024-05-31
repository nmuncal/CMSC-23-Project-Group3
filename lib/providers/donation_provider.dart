import 'dart:async';

import 'package:cmsc_23_project_group3/api/firebase_donation_api.dart';
import 'package:flutter/material.dart';
import '../models/donation_model.dart';

class DonationProvider with ChangeNotifier {
  FirebaseDonationAPI firebaseService = FirebaseDonationAPI();
  late Stream<List<Donation>> _donationStream = Stream.empty();
  Donation? _donation;
  StreamSubscription<Donation?>? _subscription;


  Donation? get donation => _donation;
  Stream<List<Donation>> get donationStream => _donationStream;
  
  late Stream<List<Donation>> _profileStream = Stream.empty();
  Stream<List<Donation>> get profileStream => _profileStream;

   void setDonationId(String donationId) {
    _subscription?.cancel();
    _subscription =
        firebaseService.getDonationInfo(donationId).listen((donation) {
      _donation = donation;
      notifyListeners();
    });
  }

  void fetchDonationsGiven(String? uid) {
    try {
      _donationStream = Stream.empty();
      _profileStream = Stream.empty();
      if (uid != null) {
        _donationStream = firebaseService.fetchDonationsGiven(uid);
        _profileStream = firebaseService.fetchDonationsGiven(uid);
      };
      notifyListeners();
    } catch (e) {
      print('Error fetching donations: $e');
      _donationStream = Stream.empty();
      _profileStream = Stream.empty();
      notifyListeners();
    }
  }

  void fetchDonationsReceived(String uid) {
    try {
      _donationStream = firebaseService.fetchDonationsReceived(uid);
      notifyListeners();
    } catch (e) {
      print('Error fetching donations: $e');
      _donationStream = Stream.empty();
      notifyListeners();
    }
  }

  Future<String> addDonation(Donation donation) async {
    String message =
        await firebaseService.addDonation(donation.toJson(donation));
    notifyListeners();
    return message;
  }

  Future<String?> updateDonation(String id, Donation details) async {
    String? message =
        await firebaseService.updateDonation(id, details.toJson(details));
    notifyListeners();
    return message;
  }

  Future<String?> updateDonationStatus(String id, String status) async {
    String? message = await firebaseService.updateDonationStatus(id, status);
    notifyListeners();
    return message;
  }

  Future<String?> fetchDonationStatus(String id) async {
    String? message = await firebaseService.fetchDonationStatus(id);
    notifyListeners();
    return message;
  }
}
