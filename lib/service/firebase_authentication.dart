import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
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

// ! Sign Out
  Future<void> signOut(BuildContext context) async {
    try {
      await auth.signOut();
    } on FirebaseAuthException catch (e) {
      BrandSnackbar.showSnackBar(context, e.message!);
    } catch (e) {
      BrandSnackbar.showSnackBar(context, e.toString());
    }
  }

// ! Sign in with Email and Password
  Future<AuthUser?> signInWithEmailAndPassword(
      String email, String password, BuildContext context) async {
    try {
      final UserCredential result = await auth.signInWithEmailAndPassword(
          email: email, password: password);
      final User? user = result.user;
      return _userFromFirebase(user!);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        BrandSnackbar.showSnackBar(
            context, 'No user found for that email. Please register');
      } else if (e.code == 'wrong-password') {
        BrandSnackbar.showSnackBar(context, 'Password is invalid.');
      }
    }
    return null;
  }

// ! Register with Email and Password
  Future<AuthUser?> createUserWithEmailAndPassword(
      String password, BuildContext context, String email) async {
    try {
      final UserCredential result = await auth.createUserWithEmailAndPassword(
          email: email, password: password);
      final User? user = result.user;
      return _userFromFirebase(user!);
    } on FirebaseAuthException catch (e) {
      BrandSnackbar.showSnackBar(context, e.message.toString());
      return null;
    } catch (e) {
      BrandSnackbar.showSnackBar(context, e.toString());
      return null;
    }
  }

  // ! Delete User
  Future<void> deleteUser(String groupId, BuildContext context) async {
    try {
      final store = FirestoreService();
      await store
          .deleteGroupPassword(groupId, true, context)
          .then((value) => store.deleteGroupPassword(groupId, false, context))
          .then((value) => auth.currentUser?.delete());
    } on FirebaseAuthException catch (e) {
      BrandSnackbar.showSnackBar(context, e.message.toString());
    } catch (e) {
      BrandSnackbar.showSnackBar(context, e.toString());
    }
  }

  // ! Reset Password
  Future<void> resetPassword(String email, BuildContext context) async {
    try {
      await auth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      BrandSnackbar.showSnackBar(context, e.message.toString());
    } catch (e) {
      BrandSnackbar.showSnackBar(context, e.toString());
    }
  }

  // ! Update Email
  Future<void> updateEmail(String email, BuildContext context) async {
    try {
      await auth.currentUser!.updateEmail(email);
    } on FirebaseAuthException catch (e) {
      BrandSnackbar.showSnackBar(context, e.message.toString());
    } catch (e) {
      BrandSnackbar.showSnackBar(context, e.toString());
    }
  }
}
