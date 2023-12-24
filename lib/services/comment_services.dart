// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

import '../models/comment_model.dart';
import '../providers/loading_controller.dart';
import '../utils/custom_messanger.dart';
import 'notification_services.dart';

class CommentServices {
  addingComment({
    required BuildContext context,
    required String comment,
    required String postId,
    required String postCreatorId,
  }) async {
    if (comment.isEmpty) {
      showMessage(context, 'Type Your Comment First');
    } else {
      try {
        Provider.of<LoadingController>(context, listen: false).setLoading(true);
        String commentId = const Uuid().v1();
        DocumentSnapshot snapshot = await FirebaseFirestore.instance
            .collection('users')
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .get();

        CommentModel commentModel = CommentModel(
          commentId: commentId,
          username: snapshot['username'],
          userId: FirebaseAuth.instance.currentUser!.uid,
          postId: postId,
          userImage: snapshot['imageUrl'],
          comment: comment,
          createdAt: DateTime.now(),
          likes: [],
        );

        await FirebaseFirestore.instance
            .collection("posts")
            .doc(postId)
            .collection("comments")
            .doc(commentId)
            .set(commentModel.toMap());
        await NotificationServices().sendPushNotification(
          userId: postCreatorId,
          body: "Comment On Your Post",
          title: snapshot['username'],
        );
        await NotificationServices().addNotificationInDB(
          context: context,
          toUserId: postCreatorId,
          title: snapshot['username'] + "Comment On Your Post",
          userImage: snapshot['imageUrl'],
        );

        Provider.of<LoadingController>(context, listen: false)
            .setLoading(false);

        showMessage(context, 'Comment Is Added SuccessFully');
      } on FirebaseException catch (e) {
        Provider.of<LoadingController>(context, listen: false)
            .setLoading(false);
        showMessage(context, e.message!);
      }
    }
  }

  replyOnComment({
    required BuildContext context,
    required String postId,
    required String commentId,
    required String replyMsg,
  }) async {
    if (replyMsg.isEmpty) {
      showMessage(context, 'Type Something');
    } else {
      try {
        DocumentSnapshot snap = await FirebaseFirestore.instance
            .collection('users')
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .get();
        await FirebaseFirestore.instance
            .collection('posts')
            .doc(postId)
            .collection('comments')
            .doc(commentId)
            .collection('reply')
            .add({
          "username": snap['username'],
          "userImage": snap['imageUrl'],
          "createdAt": DateTime.now(),
          "text": replyMsg,
        });
      } on FirebaseException catch (e) {
        showMessage(context, e.message!);
      }
    }
  }

  likeComment(BuildContext context, String postId, String commentId,
      List<dynamic> snap) async {
    if (snap.contains(FirebaseAuth.instance.currentUser!.uid)) {
      try {
        await FirebaseFirestore.instance
            .collection("posts")
            .doc(postId)
            .collection("comments")
            .doc(commentId)
            .update({
          "likes":
              FieldValue.arrayRemove([FirebaseAuth.instance.currentUser!.uid]),
        });
      } catch (e) {
        showMessage(context, e.toString());
      }
    } else {
      try {
        await FirebaseFirestore.instance
            .collection("posts")
            .doc(postId)
            .collection("comments")
            .doc(commentId)
            .update({
          "likes":
              FieldValue.arrayUnion([FirebaseAuth.instance.currentUser!.uid]),
        });
      } catch (e) {
        showMessage(context, e.toString());
      }
    }
  }
}
