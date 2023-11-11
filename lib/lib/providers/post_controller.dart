// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:chitchat/lib/services/notification_services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

import '../models/post_model.dart';
import '../screens/dashboard/bottom_nav_bar.dart';
import '../services/firebase_storage_services.dart';
import '../utils/custom_messanger.dart';
import 'loading_controller.dart';

class PostController extends ChangeNotifier {
  final List<PostModel> _postList = [];
  final List<PostModel> _myPostList = [];

  List<PostModel> get postList => _postList;
  List<PostModel> get myPostList => _myPostList;

  uploadPostImages({
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

      Navigator.of(context, rootNavigator: true)
          .pushReplacement(MaterialPageRoute(builder: (context) => const BottomNavBar()));

      showMessage(context, 'Post Uploaded Successfully');
    } on FirebaseException catch (e) {
      Provider.of<LoadingController>(context, listen: false).setLoading(false);
      showMessage(context, e.message!);
    }
  }

  uploadVideoInPost({
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

      Navigator.of(context, rootNavigator: true)
          .pushReplacement(MaterialPageRoute(builder: (context) => const BottomNavBar()));

      showMessage(context, 'Post Uploaded Successfully');
    } on FirebaseException catch (e) {
      Provider.of<LoadingController>(context, listen: false).setLoading(false);
      showMessage(context, e.message!);
    }
  }

  getAllPosts() async {
    try {
      QuerySnapshot postSnap =
          await FirebaseFirestore.instance.collection("posts").orderBy("createdAt", descending: true).get();

      if (postSnap.docs.isNotEmpty) {
        _postList.clear();
        for (var i in postSnap.docs) {
          PostModel postModel = PostModel.fromDoc(i);
          _postList.add(postModel);
          notifyListeners();
        }
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> likeAndDislikePost({BuildContext? context, required String postId, required postCreatorId}) async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      DocumentSnapshot snap =
          await FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).get();

      final index = _postList.indexWhere((post) => post.postId == postId);

      if (index != -1) {
        if (_postList[index].likes.contains(user!.uid)) {
          await FirebaseFirestore.instance.collection("posts").doc(postId).update({
            "likes": FieldValue.arrayRemove([user.uid]),
          });
          _postList[index].likes.remove(user.uid);
        } else {
          await FirebaseFirestore.instance.collection("posts").doc(postId).update({
            "likes": FieldValue.arrayUnion([user.uid]),
          });
          await NotificationServices()
              .sendPushNotification(userId: postCreatorId, body: "Like Your Post", title: '${snap['username']}');
          await NotificationServices().addNotificationInDB(
            context: context!,
            toUserId: postCreatorId,
            title: snap['username'] + "Like your Post",
            userImage: snap['imageUrl'],
          );
          _postList[index].likes.add(user.uid);
        }
        notifyListeners();
      }
    } on FirebaseException catch (e) {
      showMessage(context!, e.message.toString());
    }
  }

  deletePost({required BuildContext context, required, required int index}) async {
    try {
      await FirebaseFirestore.instance.collection('posts').doc(_postList[index].postId).delete();
      Navigator.pop(context);
      _postList.removeAt(index);
      showMessage(context, 'Post Deleted Successfully');
      notifyListeners();
    } on FirebaseException catch (e) {
      showMessage(context, e.message!);
    }
  }

  getAllMyPosts({required BuildContext context, required String userId}) async {
    try {
      QuerySnapshot snapshot =
          await FirebaseFirestore.instance.collection('posts').where('uid', isEqualTo: userId).get();
      if (snapshot.docs.isNotEmpty) {
        myPostList.clear();
        for (var i in snapshot.docs) {
          PostModel postModel = PostModel.fromDoc(i);
          _myPostList.add(postModel);
          notifyListeners();
        }
      }
    } on FirebaseException catch (e) {
      showMessage(context, e.message!);
    }
  }
}
