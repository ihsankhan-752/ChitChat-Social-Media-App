// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../models/post_model.dart';
import '../services/notification_services.dart';
import '../widgets/custom_messanger.dart';

class PostController extends ChangeNotifier {
  final List<PostModel> _postList = [];
  final List<PostModel> _myPostList = [];

  List<PostModel> get postList => _postList;
  List<PostModel> get myPostList => _myPostList;

  Future<void> getAllPosts() async {
    try {
      await FirebaseFirestore.instance.collection("posts").orderBy("createdAt", descending: true).snapshots().listen((postSnap) {
        if (postSnap.docs.isNotEmpty) {
          _postList.clear();
          for (var i in postSnap.docs) {
            PostModel postModel = PostModel.fromDoc(i);
            _postList.add(postModel);
          }
        }
        notifyListeners();
      });
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
        _postList.clear();
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

  Future<void> deletePost({required BuildContext context, required, required int index}) async {
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

  Future<void> getAllMyPosts({required BuildContext context, required String userId}) async {
    try {
      QuerySnapshot snapshot = await FirebaseFirestore.instance.collection('posts').where('uid', isEqualTo: userId).get();
      if (snapshot.docs.isNotEmpty) {
        _myPostList.clear();
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
