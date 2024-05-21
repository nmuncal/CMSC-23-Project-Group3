import 'package:cmsc_23_project_group3/api/firebase_storage_api.dart';
import 'package:flutter/foundation.dart';
import 'dart:io';



class UserStorageProvider extends ChangeNotifier {
  final  storageService = FirebaseStorageAPI();

  Future<List<String>> uploadMultipleFiles(List<File> files,String path) async {
    final downloadUrls = await storageService.uploadMultipleFiles(files,path);
    notifyListeners();
    return downloadUrls;
  }

  Future<String> uploadSingleFile(File file,String path) async {
    final downloadUrl = await storageService.uploadFile(file,path);
    notifyListeners();
    return downloadUrl;
  }
}








 