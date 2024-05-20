import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../api/firebase_main_api.dart';
import '../models/user_model.dart';

class UserProvider with ChangeNotifier {
  FirebaseTodoAPI fbService = FirebaseTodoAPI();

  // Initialize the stream with an empty stream to avoid null issues.
  late Stream<List<AppUser>> _uStream = Stream.empty();

  final int donorAcc = 0, orgAcc = 1, adminAcc = 2;

  Stream<List<AppUser>> get uStream => _uStream;

  // Private method to handle the fetching logic.
  void _fetchUsersByType(int accountType) {
    try {
      _uStream = fbService.fetchUsersByAccountType(accountType);
      notifyListeners();
    } catch (e) {
      print('Error fetching users: $e');
      _uStream = Stream.empty();
      notifyListeners();
    }
  }

  // Public methods to fetch specific user types.
  void fetchDonors() {
    _fetchUsersByType(donorAcc);
  }

  void fetchOrganizations() {
    _fetchUsersByType(orgAcc);
  }

  void fetchAdmins() {
    _fetchUsersByType(adminAcc);
  }
}
