import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cmsc_23_project_group3/models/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseUserAPI {
  static final FirebaseFirestore db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Stream<List<AppUser>> fetchUsers() {
    try {
      return db
          .collection('users')
          .snapshots()
          .map((querySnapshot) {
        return querySnapshot.docs.map((doc) {
          return AppUser.fromJson(doc.data());
        }).toList();
      });
    } catch (e) {
      print("Error getting Users: $e");
      return Stream.error("Error getting Users: $e");
    }
  }

  Stream<List<AppUser>> fetchUsersByAccountType(
      int accountType, bool approvalStatus) {
    try {
      return db
          .collection('users')
          .where('accountType', isEqualTo: accountType)
          .where('isApproved', isEqualTo: approvalStatus)
          .snapshots()
          .map((querySnapshot) {
        return querySnapshot.docs.map((doc) {
          return AppUser.fromJson(doc.data());
        }).toList();
      });
    } catch (e) {
      print("Error getting Users: $e");
      return Stream.error("Error getting Users: $e");
    }
  }

  Future<String?> updateUser(String id, Map<String, dynamic> details) async {
    try {
      await db.collection('users').doc(id).update(details);
    } catch (e) {
      print("Error getting current user ID: $e");
      return null;
    }
    return null;
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

 Future<bool> isUsernameUnique(String username) async {
  try {
    QuerySnapshot querySnapshot = await db
        .collection('users')
        .where('username', isEqualTo: username)
        .get();

    // Logging the size of the query result
    print('Query size: ${querySnapshot.size}');

    if (querySnapshot.size == 0) {
      return true;
    }
    return false;
  } catch (e) {
    // Logging the error
    print('Error in isUsernameUnique: $e');
    return false;
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
