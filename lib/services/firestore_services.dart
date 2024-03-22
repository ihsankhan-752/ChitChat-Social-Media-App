import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

import '../utils/custom_messanger.dart';
import 'firebase_storage_services.dart';

class fireStoreServices {
  userChat({
    BuildContext? context,
    String? myId,
    String? userId,
    String? docId,
    String? msg,
    String? imageUrl,
  }) async {
    DocumentSnapshot userSnap = await FirebaseFirestore.instance.collection("users").doc(myId).get();
    try {
      // String imageUrl = await storageServices().uploadPhoto(image);
      DocumentSnapshot snap = await FirebaseFirestore.instance.collection("chat").doc(docId).get();
      if (snap.exists) {
        await FirebaseFirestore.instance.collection("chat").doc(docId).update({
          "lastMsg": msg,
          "createdAt": DateTime.now(),
        });
      } else {
        await FirebaseFirestore.instance.collection("chat").doc(docId).set({
          "lastMsg": msg,
          "userIds": [myId, userId],
          "createdAt": DateTime.now(),
        });
      }
      await FirebaseFirestore.instance.collection("chat").doc(docId).collection("messages").add({
        "msg": msg,
        "senderId": myId,
        "userImage": userSnap['imageUrl'],
        "username": userSnap['username'],
        "createdAt": DateTime.now(),
        "image": imageUrl,
      });
    } catch (e) {
      showMessage(context!, e.toString());
    }
  }

  uploadStory(BuildContext context, String story, File image) async {
    DocumentSnapshot snap =
        await FirebaseFirestore.instance.collection("users").doc(FirebaseAuth.instance.currentUser!.uid).get();

    String imageUrl = await StorageServices().uploadPhoto(image);

    await FirebaseFirestore.instance.collection("stories").add({
      "uid": FirebaseAuth.instance.currentUser!.uid,
      "storyImage": imageUrl,
      "text": story,
      "userCheckedList": [],
      "createdAt": DateTime.now(),
      "username": snap['username'],
      "userImage": snap['image'],
    });
  }
}
