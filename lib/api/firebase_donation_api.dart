import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cmsc_23_project_group3/models/donation_model.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseDonationAPI {
  static final FirebaseFirestore db = FirebaseFirestore.instance;

  Future<String> addDonation(
      Map<String, dynamic> donation, String userId, String type) async {
    try {
      if (type == "donor") {
        DocumentReference doc = await db
            .collection("users")
            .doc(userId)
            .collection("donationsGiven")
            .add(donation);

        return doc.id;
      }

      if (type == "recipient") {
        DocumentReference doc = await db
            .collection("users")
            .doc(userId)
            .collection("donationsReceived")
            .add(donation);

        return doc.id;
      }

      return "";
    } on FirebaseException catch (e) {
      return "Error in ${e.code}: ${e.message}";
    }
  }

  Stream<List<Donation>> fetchDonations(String userId) {
    try {
      return db
          .collection("users")
          .doc(userId)
          .collection("donationsGiven")
          .snapshots()
          .map((querySnapshot) {
        return querySnapshot.docs.map((doc) {
          return Donation.fromJson(doc.data() as Map<String, dynamic>);
        }).toList();
      });
    } catch (e) {
      print("Error getting donations: $e");
      return Stream.error("Error getting donations: $e");
    }
  }

  //TODO: ADD UPDATE DONATION STATUS

}
