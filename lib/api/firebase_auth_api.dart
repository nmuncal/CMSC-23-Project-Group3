import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cmsc_23_project_group3/models/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

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
      return "Successful!";
    } on FirebaseAuthException catch (e) {
      if (e.code == 'invalid-email') {
        return e.message;
      } else if (e.code == 'invalid-credential') {
        return e.message;
      } else if (e.code == 'wrong-password') {
        return e.message;
      } else if (e.code == 'user-not-found') {
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
          uid: credential.user!.uid,
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

  Future<String?> fetchEmail(String username) async {
    try {
      QuerySnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
          .instance
          .collection('users')
          .where("username", isEqualTo: username)
          .get();

      if (snapshot.docs.isNotEmpty) {
        return snapshot.docs.first.get('email') as String?;
      } else {
        return null; // User not found
      }
    } catch (e) {
      print("Error fetching email: $e");
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

  Future<void> signOut() async {
    await auth.signOut();
  }

  Future<String?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      UserCredential account = await auth.signInWithCredential(credential);
      return account.user!.email;
    } on Exception catch (e) {
      return 'exception->$e';
    }
  }
}
