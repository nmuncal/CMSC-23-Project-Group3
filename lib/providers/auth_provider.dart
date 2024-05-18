import 'package:cmsc_23_project_group3/api/firebase_auth_api.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserAuthProvider with ChangeNotifier {
  late FirebaseAuthAPI authService;
  late Stream<User?> _uStream;
  late Stream<bool?> _uApprovalStatus;

  UserAuthProvider() {
    authService = FirebaseAuthAPI();
    fetchAuthentication();
  }

  Stream<User?> get userStream => _uStream;
  Stream<bool?> get userApprovalStatus => _uApprovalStatus;
  User? get user => authService.getUser();


  User? getUser() {
    return user;
  }

  void fetchAuthentication() {
    _uStream = authService.userSignedIn();
    notifyListeners();
  }

  Future<String?> signUp(
    String email, String password,String username, String name, String contactNo, List<String> address,int accountType,bool isApproved) async {
    String? uid = await authService.signUp(email, password, username, name, contactNo, address, accountType,isApproved);
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
    notifyListeners();
  }

  Future<int?> getAccountType() async {
    int? accountType = await authService.getAccountType();
    notifyListeners();
    return accountType;
  }

  Future<bool?> getApprovalStatus() async {
    bool? isApproved = await authService.getUserApprovalStatus();
    notifyListeners();
    return isApproved;
  }

}
