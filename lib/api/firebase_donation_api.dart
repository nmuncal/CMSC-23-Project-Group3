import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cmsc_23_project_group3/models/donation_model.dart';


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

   Future<String?> fetchDonationStatus(String id) async {
    try {
      DocumentSnapshot donationSnapshot =
          await db.collection('donations').doc(id).get();
      if (donationSnapshot.exists) {
        return donationSnapshot['status'];
      } else {
        return 'Error: Donation status not found for donation ID $id';
      }
    } catch (e) {
      return 'Error fetching status for donation ID $id: $e';
    }
  }

  Future<String?> fetchDonationRecipient(String id) async {
    try {
      DocumentSnapshot donationSnapshot =
          await db.collection('donations').doc(id).get();
      if (donationSnapshot.exists) {
        return donationSnapshot['recipientId'];
      } else {
        return 'Error: Donation recipient not found for donation ID $id';
      }
    } catch (e) {
      return 'Error fetching recipient id for donation ID $id: $e';
    }
  }

  Future<String?> updateDonationStatus(String id,String status) async {
    try {
      await db.collection('donations').doc(id).update({'status': status});
      return 'Status updated successfully';
    } catch (e) {
      print('Error updating status for donation ID $id: $e');
      return 'Error updating status';
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

  Stream<Donation?> getDonationInfo(String donationId) {
    return db
        .collection('donations')
        .doc(donationId)
        .snapshots()
        .map((snapshot) {
      if (snapshot.exists) {
        return Donation.fromJson(snapshot.data() as Map<String, dynamic>);
      }
      return null;
    });
  }
}
