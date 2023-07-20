import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthRepository {
  final googleSignIn = GoogleSignIn();
  final firebaseAuth = FirebaseAuth.instance;
  // final firebase = FirebaseAuth.instance;
  final fireBaseStore = FirebaseFirestore.instance;

  Future<void> signUp({required String email, required String password}) async {
    try {
      firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak password') {
        throw Exception('This password is to weak');
      } else if (e.code == 'email already exist') {
        throw Exception("The account already exist for that email ");
      }
    } catch (e) {
      throw Exception(e.toString());
      // print(e);
    }
  }

  Future<UserCredential> signInWithGoogle() async {
    final GoogleSignInAccount? googleSignInAccount =
        await googleSignIn.signIn();
    final GoogleSignInAuthentication googleSignInAuth =
        await googleSignInAccount!.authentication;
    final AuthCredential credential = GoogleAuthProvider.credential(
      idToken: googleSignInAuth.idToken,
      accessToken: googleSignInAuth.accessToken,
    );
    return await firebaseAuth.signInWithCredential(credential);
  }

  Future<void> signInWithEmail(
      {required String email, required String password}) async {
    try {
      final credential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
      }
    }
  }

  bool isUserLoggedIn() {
    return firebaseAuth.currentUser != null;
  }

  Future<void> signOut() async {
    try {
      await firebaseAuth.signOut();
    } catch (e) {
      print('Sign Out Error: $e');
    }
  }

  Future<void> signInAnonymously() async {
    try {
      UserCredential userCredential = await firebaseAuth.signInAnonymously();
      User? user = userCredential.user;
      if (user != null) {}
    } catch (e) {
      print('Anonymous Sign-In Error: $e');
    }
  }

  Future<void> deleteTask(id) async {
    await fireBaseStore
        .collection("tasks")
        .doc(FirebaseAuth.instance.currentUser?.uid)
        .collection("userTasks")
        .doc(id)
        .delete();
  }
}
