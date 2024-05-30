import 'dart:async';

import 'package:cmsc_23_project_group3/api/firebase_donationdrive_api.dart';
import 'package:cmsc_23_project_group3/models/donationDrive_model.dart';
import 'package:flutter/material.dart';

class DonationDriveProvider with ChangeNotifier {
  FirebaseDonationDriveAPI firebaseService = FirebaseDonationDriveAPI();
  late Stream<List<DonationDrive>> _driveStream = Stream.empty();
  DonationDrive? _drive;
  StreamSubscription<DonationDrive?>? _subscription;
  DonationDrive? get drive => _drive;
  Stream<List<DonationDrive>> get driveStream => _driveStream;

  void setDonationDriveId(String donationDriveId) {
    _subscription?.cancel();
    _subscription =
        firebaseService.getDriveInfo(donationDriveId).listen((drive) {
      _drive = drive;
      notifyListeners();
    });
  }

  void fetchDrives(String uid) {
    try {
      _driveStream = firebaseService.fetchdrives(uid);
      notifyListeners();
    } catch (e) {
      print('Error fetching donation drives: $e');
      _driveStream = Stream.empty();
      notifyListeners();
    }
  }

  Future<String?> linkDonationToDrive(String id, String donationId) async {
    String? message = await firebaseService.linkDonationToDrive(id, donationId);
    notifyListeners();
    return message;
  }

  Future<String?> updateDriveDetails(String id, DonationDrive details) async {
    String? message =
        await firebaseService.updateDriveDetails(id, details.toJson(details));
    notifyListeners();
    return message;
  }

  Future<String?> updateDriveName(String id, String name) async {
    String? message = await firebaseService.updateDriveName(id, name);
    notifyListeners();
    return message;
  }
}
