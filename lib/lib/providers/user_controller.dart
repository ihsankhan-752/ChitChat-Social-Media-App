// ignore_for_file: use_build_context_synchronously

import 'package:chitchat/lib/models/user_model.dart';
import 'package:chitchat/lib/services/notification_services.dart';
import 'package:chitchat/lib/utils/custom_messanger.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

class UserController extends ChangeNotifier {
  UserModel? _userModel;
  UserModel get userModel => _userModel!;

  getUserData() async {
    try {
      DocumentSnapshot snapshot =
          await FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).get();

      if (snapshot.exists) {
        _userModel = UserModel.fromDocumentSnapshot(snapshot);
      } else {
        throw 'No User Found';
      }
      notifyListeners();
    } on FirebaseException catch (e) {
      print(e);
    }
  }

  followAndUnFollowUser(BuildContext context, String userId) async {
    try {
      DocumentSnapshot snap = await FirebaseFirestore.instance.collection('users').doc(userId).get();
      DocumentSnapshot userSnap =
          await FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).get();

      if (snap['followers'].contains(FirebaseAuth.instance.currentUser!.uid)) {
        await FirebaseFirestore.instance.collection('users').doc(userId).update({
          'followers': FieldValue.arrayRemove([FirebaseAuth.instance.currentUser!.uid]),
        });
        await FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).update({
          'following': FieldValue.arrayRemove([userId]),
        });

        showMessage(context, "You Are UnFollow This User");
      } else {
        await FirebaseFirestore.instance.collection('users').doc(userId).update({
          'followers': FieldValue.arrayUnion([FirebaseAuth.instance.currentUser!.uid]),
        });
        await FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).update({
          'following': FieldValue.arrayUnion([userId]),
        });
        await NotificationServices().sendPushNotification(
          userId: userId,
          body: "Start Following You",
          title: userSnap['username'],
        );
        await NotificationServices().addNotificationInDB(
          context: context,
          toUserId: userId,
          title: userSnap['username'] + "Start Following You",
          userImage: userSnap['imageUrl'],
        );

        showMessage(context, "You Are Follow This User");
      }
      notifyListeners();
    } on FirebaseException catch (e) {
      showMessage(context, e.message!);
    }
  }
}
