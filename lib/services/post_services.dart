import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

import '../models/post_model.dart';
import '../providers/loading_controller.dart';
import '../screens/dashboard/bottom_nav_bar.dart';
import '../utils/custom_messanger.dart';
import 'firebase_storage_services.dart';

class PostServices {
  Future<void> uploadPostImages({
    required BuildContext context,
    required List<XFile> imageFileList,
    required String postMsg,
  }) async {
    try {
      Provider.of<LoadingController>(context, listen: false).setLoading(true);

      List imageUrlList = [];
      String postId = const Uuid().v4();
      DocumentSnapshot snap =
          await FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).get();

      for (var image in imageFileList) {
        FirebaseStorage firebaseStorage = FirebaseStorage.instance;
        Reference ref = firebaseStorage.ref().child(DateTime.now().millisecondsSinceEpoch.toString());
        await ref.putFile(File(image.path));
        await ref.getDownloadURL();
        imageUrlList.add(await ref.getDownloadURL());
      }
      PostModel postModel = PostModel(
        uid: FirebaseAuth.instance.currentUser!.uid,
        postId: postId,
        userName: snap['username'],
        userImage: snap['imageUrl'],
        postImages: imageUrlList,
        postTitle: postMsg,
        videoUrl: '',
        createdAt: DateTime.now(),
        likes: [],
      );
      await FirebaseFirestore.instance.collection('posts').doc(postId).set(postModel.toMap());
      Provider.of<LoadingController>(context, listen: false).setLoading(false);

      Navigator.of(context, rootNavigator: true).pushReplacement(MaterialPageRoute(builder: (context) => const BottomNavBar()));

      showMessage(context, 'Post Uploaded Successfully');
    } on FirebaseException catch (e) {
      Provider.of<LoadingController>(context, listen: false).setLoading(false);
      showMessage(context, e.message!);
    }
  }

  Future<void> uploadVideoInPost({
    required BuildContext context,
    required File videoUrl,
    required String postMsg,
  }) async {
    try {
      Provider.of<LoadingController>(context, listen: false).setLoading(true);

      String postId = const Uuid().v4();
      DocumentSnapshot snap =
          await FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).get();
      String url = await StorageServices().uploadPhoto(videoUrl);

      PostModel postModel = PostModel(
        uid: FirebaseAuth.instance.currentUser!.uid,
        postId: postId,
        userName: snap['username'],
        userImage: snap['imageUrl'],
        postImages: [],
        postTitle: postMsg,
        videoUrl: url,
        createdAt: DateTime.now(),
        likes: [],
      );
      await FirebaseFirestore.instance.collection('posts').doc(postId).set(postModel.toMap());
      Provider.of<LoadingController>(context, listen: false).setLoading(false);

      Navigator.of(context, rootNavigator: true).pushReplacement(MaterialPageRoute(builder: (context) => const BottomNavBar()));

      showMessage(context, 'Post Uploaded Successfully');
    } on FirebaseException catch (e) {
      Provider.of<LoadingController>(context, listen: false).setLoading(false);
      showMessage(context, e.message!);
    }
  }

  Future<void> likeAndUnlikePost(PostModel postModel, String postId) async {
    try {
      if (postModel.likes.contains(FirebaseAuth.instance.currentUser!.uid)) {
        await FirebaseFirestore.instance.collection('posts').doc(postId).update({
          "likes": FieldValue.arrayRemove([FirebaseAuth.instance.currentUser!.uid])
        });
      } else {
        await FirebaseFirestore.instance.collection('posts').doc(postId).update({
          "likes": FieldValue.arrayUnion([FirebaseAuth.instance.currentUser!.uid])
        });
      }
    } on FirebaseException catch (e) {
      print(e);
    }
  }

  Future<void> savePost(List bookMarkList, String postId) async {
    try {
      if (bookMarkList.contains(postId)) {
        await FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).update({
          'bookMarks': FieldValue.arrayRemove([postId]),
        });
      } else {
        await FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).update({
          'bookMarks': FieldValue.arrayUnion([postId]),
        });
      }
    } on FirebaseException catch (e) {
      print(e);
    }
  }
}
