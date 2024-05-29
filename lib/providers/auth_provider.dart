import 'dart:async';

import 'package:cmsc_23_project_group3/api/firebase_auth_api.dart';
import 'package:cmsc_23_project_group3/api/firebase_user_api.dart';
import 'package:cmsc_23_project_group3/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/user_model.dart';

class UserAuthProvider with ChangeNotifier {
  late FirebaseAuthAPI authService;
  late Stream<User?> _authStream;
  bool? _userApprovalStatus;
  AppUser? _accountInfo;
  Stream<List<AppUser>>? _dbStream;
  bool unique = false;

  UserAuthProvider() {
    authService = FirebaseAuthAPI();
    _initializeStreams();
  }

  void refresh() {
    _getAccountInfo();
    getApprovalStatus();
  }

  Stream<User?> get userStream => _authStream;
  User? get user => authService.getUser();
  bool? get userApprovalStatus => _userApprovalStatus;
  AppUser? get accountInfo => _accountInfo;

  void _initializeStreams() {
    _authStream = authService.userSignedIn();

    _authStream = authService.userSignedIn();
    _authStream.listen((user) {
      refresh();
    });

    _dbStream = FirebaseUserAPI().fetchUsers();
    _dbStream!.listen((users) {
      refresh();
    });

    notifyListeners();
  }

  String? _email;
  String? get email => _email;

  Future<void> fetchEmail(username) async {
    _email = await authService.fetchEmail(username);
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
      String email,
      String password,
      String username,
      String name,
      String contactNo,
      List<String> address,
      int accountType,
      bool isApproved) async {
    String? uid = await authService.signUp(email, password, username, name,
        contactNo, address, accountType, isApproved);
    notifyListeners();
    return uid;
  }

  Future<String?> signIn(String email, String password) async {
    String? message = await authService.signIn(email, password);
    notifyListeners();
    return message;
  }

  Future<bool> isUsernameUnique(String username) async {
    unique = await authService.isUsernameUnique(username);
    notifyListeners();
    return unique;
  }

  Future<void> signOut() async {
    await authService.signOut();
    _accountInfo = null;
    notifyListeners();
  }
}
