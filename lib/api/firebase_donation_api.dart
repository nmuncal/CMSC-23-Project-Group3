import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cmsc_23_project_group3/models/donation_model.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseDonationAPI {
  static final FirebaseFirestore db = FirebaseFirestore.instance;

  Future<String> addDonation(Map<String, dynamic> donation) async {
    try {
      DocumentReference doc = await db.collection("donations").add(donation);

      return doc.id;
    } on FirebaseException catch (e) {
      return "Error in ${e.code}: ${e.message}";
    }
  }

  Stream<List<Donation>> fetchDonationsGiven(String userId) {
    try {
      return db
          .collection("donations")
          .where('donorId', isEqualTo: userId)
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

  Stream<List<Donation>> fetchDonationsReceived(String userId) {
    try {
      return db
          .collection("donations")
          .where('recipientId', isEqualTo: userId)
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

  Future<String?> updateDonation(
      String id, Map<String, dynamic> details) async {
    try {
      await db.collection('donations').doc(id).update(details);
    } catch (e) {
      print("Error getting current donation ID: $e");
      return null;
    }
    return null;
  }
}
