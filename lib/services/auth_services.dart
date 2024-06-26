// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';

import '../consts/screen_navigations.dart';
import '../models/user_model.dart';
import '../providers/loading_controller.dart';
import '../screens/auth/login_screen.dart';
import '../screens/dashboard/bottom_nav_bar.dart';
import '../widgets/custom_messanger.dart';
import 'firebase_storage_services.dart';

class AuthServices {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  signUp({
    required BuildContext context,
    required String email,
    required String password,
    required File? file,
    required String username,
    required String bio,
  }) async {
    if (email.isEmpty || password.isEmpty || username.isEmpty || bio.isEmpty) {
      showMessage(context, "All Fields are Required");
    } else {
      try {
        Provider.of<LoadingController>(context, listen: false).setLoading(true);

        await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: password);

        String? imageUrl;
        if (file != null) {
          imageUrl = await StorageServices().uploadPhoto(file);
        }

        UserModel userModel = UserModel(
          uid: FirebaseAuth.instance.currentUser!.uid,
          username: username,
          email: email,
          imageUrl: imageUrl,
          followers: [],
          following: [],
          bio: bio,
        );
        await FirebaseFirestore.instance.collection("users").doc(FirebaseAuth.instance.currentUser!.uid).set(userModel.toMap());
        Provider.of<LoadingController>(context, listen: false).setLoading(false);
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const BottomNavBar()));
      } on FirebaseAuthException catch (e) {
        Provider.of<LoadingController>(context, listen: false).setLoading(false);
        showMessage(context, e.message!);
      }
    }
  }

  signIn(BuildContext context, String email, String password) async {
    if (email.isEmpty || password.isEmpty) {
      showMessage(context, "All Fields are Required");
    } else {
      try {
        Provider.of<LoadingController>(context, listen: false).setLoading(true);

        await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password);

        await FirebaseAuth.instance.authStateChanges().first;

        User? user = FirebaseAuth.instance.currentUser;
        if (user != null) {
          QuerySnapshot snap = await FirebaseFirestore.instance.collection('users').where('email', isEqualTo: email).get();
          if (snap.docs.isNotEmpty) {
            Provider.of<LoadingController>(context, listen: false).setLoading(false);
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const BottomNavBar()));
          } else {
            Provider.of<LoadingController>(context, listen: false).setLoading(false);
            showMessage(context, "No User Found!");
          }
        } else {
          Provider.of<LoadingController>(context, listen: false).setLoading(false);
          showMessage(context, "Authentication failed");
        }
      } on FirebaseAuthException catch (e) {
        Provider.of<LoadingController>(context, listen: false).setLoading(false);
        showMessage(context, e.message!);
      }
    }
  }

  logOutUser(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    Navigator.of(context, rootNavigator: true).pushReplacement(MaterialPageRoute(builder: (context) => const LoginScreen()));
  }

  Future<UserCredential> signInWithGoogle(BuildContext context) async {
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    final GoogleSignInAuthentication googleAuth = await googleUser!.authentication;
    final credential = GoogleAuthProvider.credential(
      idToken: googleAuth.idToken,
      accessToken: googleAuth.accessToken,
    );
    return await FirebaseAuth.instance.signInWithCredential(credential).whenComplete(() async {
      await FirebaseFirestore.instance.collection("users").doc(FirebaseAuth.instance.currentUser!.uid).set({
        "uid": FirebaseAuth.instance.currentUser!.uid,
        "username": googleUser.displayName,
        "email": googleUser.email,
        "bio": '',
        "image": googleUser.photoUrl,
        'bookmarks': [],
        "followers": [],
        "following": [],
      });
      navigateToNext(context, const BottomNavBar());
    });
  }

  resetPassword(BuildContext context, String email) async {
    try {
      Provider.of<LoadingController>(context, listen: false).setLoading(true);
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      Provider.of<LoadingController>(context, listen: false).setLoading(false);
      Navigator.pop(context);
      showMessage(context, 'Please Reset Your Password and Login Again with New Password');
    } on FirebaseAuthException catch (e) {
      Provider.of<LoadingController>(context, listen: false).setLoading(false);

      showMessage(context, e.message!);
    }
  }

  static Future<bool> checkOldPassword(email, password) async {
    AuthCredential authCredential = EmailAuthProvider.credential(email: email, password: password);
    try {
      var credentialResult = await FirebaseAuth.instance.currentUser!.reauthenticateWithCredential(authCredential);
      return credentialResult.user != null;
    } catch (e) {
      print(e);
      return false;
    }
  }

  static Future<void> changeUserPassword(newPassword) async {
    try {
      await FirebaseAuth.instance.currentUser!.updatePassword(newPassword);
    } catch (e) {
      print(e);
    }
  }
}
