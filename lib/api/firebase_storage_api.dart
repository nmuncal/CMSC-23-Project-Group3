import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';

class FirebaseStorageAPI {
  static final FirebaseStorage _storage = FirebaseStorage.instance;

  Future<String> uploadFile(File file, String path) async {
    try {
      final storageRef =
          _storage.ref().child('$path/${file.path.split('/').last}');
      final uploadTask = storageRef.putFile(file);
      final TaskSnapshot snapshot = await uploadTask.whenComplete(() {});

      final String downloadURL = await snapshot.ref.getDownloadURL();

      return downloadURL;
    } on FirebaseException catch (e) {
      return 'Firebase Exception: $e';
    } catch (e) {
      return 'Error uploading file: $e';
    }
  }

  Future<List<String>> uploadMultipleFiles(
      List<File> files, String path) async {
    final downloadUrls = <String>[];
    for (final file in files) {
      final url = await uploadFile(file, path);
      downloadUrls.add(url);
    }
    return downloadUrls;
  }
}
