import 'package:chitchat/providers/loading_controller.dart';
import 'package:chitchat/services/firebase_storage_services.dart';
import 'package:chitchat/widgets/custom_messanger.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

class UserProfileServices {
  Future<void> updateProfile({BuildContext? context, String? username, String? bio}) async {
    try {
      Provider.of<LoadingController>(context!, listen: false).setLoading(true);
      await FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).update({
        'username': username,
        'bio': bio,
      });
      Provider.of<LoadingController>(context, listen: false).setLoading(false);
      Navigator.pop(context);
    } on FirebaseException catch (e) {
      showMessage(context!, e.message!);
      Provider.of<LoadingController>(context, listen: false).setLoading(false);
    }
  }

  static updateProfilePic(BuildContext context, dynamic image) async {
    try {
      Provider.of<LoadingController>(context, listen: false).setLoading(true);
      String? _imageUrl = await StorageServices().uploadPhoto(image!);
      await FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).update({
        'imageUrl': _imageUrl,
      });

      Provider.of<LoadingController>(context, listen: false).setLoading(false);
      Navigator.pop(context);
    } on FirebaseException catch (e) {
      showMessage(context, e.message!);
      Provider.of<LoadingController>(context, listen: false).setLoading(false);
    }
  }
}
