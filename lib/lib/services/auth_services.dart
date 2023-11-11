// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:chitchat/lib/models/user_model.dart';
import 'package:chitchat/lib/providers/loading_controller.dart';
import 'package:chitchat/lib/services/firebase_storage_services.dart';
import 'package:chitchat/lib/utils/custom_messanger.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';

import '../screens/auth/login_screen.dart';
import '../screens/dashboard/bottom_nav_bar.dart';
import '../utils/screen_navigations.dart';

class AuthServices {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  signUp({
    required BuildContext context,
    required String email,
    required String password,
    required File file,
    required String username,
    required String bio,
  }) async {
    if (email.isEmpty || password.isEmpty || file == null || username.isEmpty || bio.isEmpty) {
      showMessage(context, "All Fields are Required");
    } else {
      try {
        Provider.of<LoadingController>(context, listen: false).setLoading(true);

        await _auth.createUserWithEmailAndPassword(email: email, password: password);
        String imageUrl = await StorageServices().uploadPhoto(file);

        UserModel userModel = UserModel(
          uid: FirebaseAuth.instance.currentUser!.uid,
          username: username,
          email: email,
          imageUrl: imageUrl,
          followers: [],
          following: [],
          bio: bio,
        );
        await FirebaseFirestore.instance
            .collection("users")
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .set(userModel.toMap());
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
        Provider.of<LoadingController>(context, listen: false).setLoading(false);

        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const BottomNavBar()));
      } on FirebaseAuthException catch (e) {
        Provider.of<LoadingController>(context, listen: false).setLoading(false);
        showMessage(context, e.message!);
      }
    }
  }

  logOutUser(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    Navigator.of(context, rootNavigator: true)
        .pushReplacement(MaterialPageRoute(builder: (context) => const LoginScreen()));
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
}
