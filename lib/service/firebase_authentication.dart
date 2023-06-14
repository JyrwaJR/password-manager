import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:password_manager/export.dart';

class FirebaseAuthService {
  final auth = FirebaseAuth.instance;

  // ! mapping User to AuthUser
  _userFromFirebase(User? user) {
    return user != null
        ? AuthUser(user.uid, user.email, user.displayName, user.photoURL,
            user.phoneNumber, user.emailVerified, user.isAnonymous)
        : null;
  }

// ! Auth Change User Stream
  Stream<AuthUser> get getUser {
    return auth.authStateChanges().map((User? user) => _userFromFirebase(user));
  }

  // ! Delete User
  Future<void> deleteUser(BuildContext context) async {
    try {
      auth.currentUser?.delete().then((value) =>
          BrandSnackbar.showSnackBar(context, 'User Deleted Successfully'));
    } on FirebaseAuthException catch (e) {
      BrandSnackbar.showSnackBar(context, e.message.toString());
    } catch (e) {
      BrandSnackbar.showSnackBar(context, e.toString());
    }
  }

  // Create an instance of the Google SignIn service
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  // final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  Future<AuthUser?> signInWithGoogle(BuildContext context) async {
    try {
      // Sign in to Google
      final GoogleSignInAccount? googleSignInAccount =
          await _googleSignIn.signIn();
      if (googleSignInAccount != null) {
        // Obtain the authentication credentials for the user
        final GoogleSignInAuthentication googleAuth =
            await googleSignInAccount.authentication;

        // Create the Firebase credential using the obtained Google authentication credentials
        final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );
        // Sign in to Firebase using the credential
        final UserCredential userCredential =
            await auth.signInWithCredential(credential);
        final User? user = userCredential.user;
        if (user != null) {
          final _store = FirestoreService();

          await _store.registerUser(
              UserDTO(
                userName: user.displayName ?? '',
                email: user.email ?? '',
                uid: user.uid,
              ),
              context);
          return _userFromFirebase(user);
        }
      }
    } on FirebaseAuthException catch (e) {
      BrandSnackbar.showSnackBar(context, e.message.toString());
    } catch (e) {
      // Handle any errors that occur during the sign-in process
      BrandSnackbar.showSnackBar(context, e.toString());
      print('Error signing in with Google: $e');
    }

    return null;
  }

  Future<void> googleSignOut(BuildContext context) async {
    try {
      await _googleSignIn.signOut(); // Sign out from Google
      await auth.signOut().then(
          (value) => context.go('/')); // Sign out from Firebase Authentication
    } catch (e) {
      BrandSnackbar.showSnackBar(context, e.toString());
      print('Error signing out: $e');
    }
  }
}
