import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cmsc_23_project_group3/models/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseAuthAPI {
  static final FirebaseAuth auth = FirebaseAuth.instance;
  static final FirebaseFirestore db = FirebaseFirestore.instance;

  User? getUser() {
    return auth.currentUser;
  }

  Stream<User?> userSignedIn() {
    return auth.authStateChanges();
  }

  Future<bool?> getUserApprovalStatus() async {
    User? user = getUser();
    if (user == null) {
      return null;
    }

    try {
      DocumentSnapshot doc = await db.collection('users').doc(user.uid).get();
      if (doc.exists) {
        return doc['isApproved'];
      } else {
        return null;
      }
    } catch (e) {
      print("Error getting approval status: $e");
      return null;
    }
  }

  Future<String?> signIn(String email, String password) async {
    try {
      await auth.signInWithEmailAndPassword(email: email, password: password);
      return "";
    } on FirebaseAuthException catch (e) {
      if (e.code == 'invalid-email') {
        return e.message;
      } else if (e.code == 'invalid-credential') {
        return e.message;
      } else if (e.code == 'wrong-password') {
        return e.message;
      } else {
        return "Failed at ${e.code}: ${e.message}";
      }
    }
  }

  Future<String?> signUp(
      String email,
      String password,
      String username,
      String name,
      String contactNo,
      List<String> address,
      int accountType,
      bool isApproved) async {
    try {
      UserCredential credential = await auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (credential.user != null) {
        AppUser newUser = AppUser(
          email: email,
          username: username,
          name: name,
          contactNo: contactNo,
          address: address,
          accountType: accountType,
          isApproved: isApproved,
        );

        // Save user information to Firestore
        try {
          Map<String, dynamic> userData = newUser.toJson(newUser);
          await db.collection("users").doc(credential.user!.uid).set(userData);
          return credential.user!.uid;
          // Now the user is successfully added to Firestore
        } on FirebaseException catch (e) {
          return "Error in Firestore: ${e.code}: ${e.message}";
          // Handle Firestore error
        }
      } else {
        return "Error: User authentication failed.";
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        return 'Error: The account already exists for that email.';
      } else if (e.code == 'weak-password') {
        return 'Error: Weak password';
      }
    } catch (e) {
      return "Error: $e";
    }

    return "Error";
  }

  Future<void> signOut() async {
    await auth.signOut();
  }
}
