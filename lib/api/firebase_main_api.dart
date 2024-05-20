import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cmsc_23_project_group3/models/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseTodoAPI {
  static final FirebaseFirestore db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Stream<List<AppUser>> fetchUsersByAccountType(int accountType) {
    try {
      return db
          .collection('users')
          .where('accountType', isEqualTo: accountType)
          .snapshots()
          .map((querySnapshot) {
            return querySnapshot.docs.map((doc) {
              return AppUser.fromJson(doc.data() as Map<String, dynamic>);
            }).toList();
          });
    } catch (e) {
      print("Error getting Users: $e");
      return Stream.error("Error getting Users: $e");
    }
  }

    Future<String?> fetchID() async {
    try {
      User? user = _auth.currentUser;
      return user?.uid;
    } catch (e) {
      print("Error getting current user ID: $e");
      return null;
    }
  }
}