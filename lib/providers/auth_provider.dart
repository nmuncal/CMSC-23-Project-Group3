import 'dart:async';

import 'package:cmsc_23_project_group3/api/firebase_auth_api.dart';
import 'package:cmsc_23_project_group3/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/user_model.dart';

class UserAuthProvider with ChangeNotifier {
  late FirebaseAuthAPI authService;
  late Stream<User?> _userStream;
  bool? _userApprovalStatus;
  AppUser? _accountInfo;
  Timer? _timer;

  UserAuthProvider() {
    authService = FirebaseAuthAPI();
    _initializeStreams();

    _userStream.listen((user) {
      refresh();
    });

    _timer = Timer.periodic(const Duration(seconds: 10), (timer) {
      refresh();
    });
  }

  void refresh(){
    _getAccountInfo();
    getApprovalStatus();
  }

  Stream<User?> get userStream => _userStream;
  User? get user => authService.getUser();
  bool? get userApprovalStatus => _userApprovalStatus;
  AppUser? get accountInfo => _accountInfo;

  void _initializeStreams() {
    _userStream = authService.userSignedIn();
    notifyListeners();
  }

  Future<void> _getAccountInfo() async {
    if (user == null) {
      return;
    }
    _accountInfo = await UserProvider().getAccountInfo(user!.uid);
    notifyListeners();
  }

  Future<void> getApprovalStatus() async {
    _userApprovalStatus = await authService.getUserApprovalStatus();
    notifyListeners();
  }

  Future<String?> signUp(
    String email, String password, String username, String name, String contactNo, List<String> address, int accountType, bool isApproved) async {
    String? uid = await authService.signUp(email, password, username, name, contactNo, address, accountType, isApproved);
    notifyListeners();
    return uid;
  }

  Future<String?> signIn(String email, String password) async {
    String? message = await authService.signIn(email, password);
    notifyListeners();
    return message;
  }

  Future<void> signOut() async {
    await authService.signOut();
    _accountInfo = null;
    notifyListeners();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
