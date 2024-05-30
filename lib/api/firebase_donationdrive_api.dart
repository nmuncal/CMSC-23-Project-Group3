import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cmsc_23_project_group3/models/donationDrive_model.dart';

class FirebaseDonationDriveAPI {
  static final FirebaseFirestore db = FirebaseFirestore.instance;

  Future<String> adddrive(Map<String, dynamic> drive) async {
    try {
      DocumentReference doc = await db.collection("donationdrive").add(drive);

      return doc.id;
    } on FirebaseException catch (e) {
      return "Error in ${e.code}: ${e.message}";
    }
  }

  Stream<List<DonationDrive>> fetchdrives(String userId) {
    try {
      return db
          .collection("donationdrive")
          .where('organizationid', isEqualTo: userId)
          .snapshots()
          .map((querySnapshot) {
        return querySnapshot.docs.map((doc) {
          return DonationDrive.fromJson(doc.data() as Map<String, dynamic>);
        }).toList();
      });
    } catch (e) {
      print("Error getting donations: $e");
      return Stream.error("Error getting donations: $e");
    }
  }

  Future<String?> updateDriveStatus(String id, bool active) async {
    try {
      await db.collection('donationdrive').doc(id).update({'status': active});
      return 'Status updated successfully';
    } catch (e) {
      print('Error updating status for donation ID $id: $e');
      return 'Error updating status';
    }
  }

  Future<String?> updateDriveDetails(
      String id, Map<String, dynamic> details) async {
    try {
      await db.collection('donationdrive').doc(id).update(details);

      return "Details updated successfully";
    } catch (e) {
      return "Error updating drive details: $e";
    }
  }

  Future<String?> deleteDonationDrive(String id) async {
    try {
      await db.collection('donationdrive').doc(id).delete();
      return "Drive deleted successfully";
    } catch (e) {
      return "Error deleting drive: $e";
    }
  }

  Future<String?> linkDonationToDrive(String id, String donation) async {
    try {
      await db.collection('donationdrive').doc(id).update({
        'donations': FieldValue.arrayUnion([donation])
      });
      return "Donation linked successfully";
    } catch (e) {
      return "Error linking donation to drive: $e";
    }
  }


  Future<String?> updateDriveName(String id, String name) async {
    try {
      await db.collection('donationdrive').doc(id).update({'name': name});
      return "Drive name updated successfully.";
    } catch (e) {
      return "Error updating drive name: $e";
    }
  }

  Stream<DonationDrive?> getDriveInfo(String driveid) {
    return db
        .collection('donationdrive')
        .doc(driveid)
        .snapshots()
        .map((snapshot) {
      if (snapshot.exists) {
        return DonationDrive.fromJson(snapshot.data() as Map<String, dynamic>);
      }
      return null;
    });
  }
}
