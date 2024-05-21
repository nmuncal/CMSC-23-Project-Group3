import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cmsc_23_project_group3/models/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseUserAPI {
  static final FirebaseFirestore db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Stream<List<AppUser>> fetchUsersByAccountType(int accountType,bool approvalStatus) {
    try {
      return db
          .collection('users')
          .where('accountType', isEqualTo: accountType)
          .where('isApproved', isEqualTo: approvalStatus)
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

  Future<AppUser?> getAccountInfo(String id) async {
    try {
      DocumentSnapshot doc = await db.collection('users').doc(id).get();
      if (doc.data() != null) {
        return AppUser.fromJson(doc.data() as Map<String, dynamic>);
      } else {
        return null;
      }
    } on FirebaseException catch (e) {
      print("Error getting account info: $e");
      return null;
    } catch (e) {
      // Handle other unexpected exceptions
      print("Unexpected error: $e");
      return null;
    }
  }
}