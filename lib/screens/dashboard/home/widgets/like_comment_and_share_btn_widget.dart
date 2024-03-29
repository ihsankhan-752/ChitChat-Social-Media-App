import 'package:chitchat/models/post_model.dart';
import 'package:chitchat/models/user_model.dart';
import 'package:chitchat/services/post_services.dart';
import 'package:chitchat/themes/colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';

import '../../../../utils/screen_navigations.dart';
import '../../minor_screen/comment_screen/comment_screen.dart';

class LikeCommentShareButtonWidget extends StatelessWidget {
  final PostModel postModel;
  final String? postId;
  const LikeCommentShareButtonWidget({super.key, required this.postModel, this.postId});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Row(
        children: [
          StreamBuilder<DocumentSnapshot>(
              stream: FirebaseFirestore.instance.collection('posts').doc(postId).snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }

                PostModel _post = PostModel.fromDoc(snapshot.data!);

                return GestureDetector(
                  onTap: () {
                    PostServices().likeAndUnlikePost(context, _post, postId!);
                  },
                  child: Icon(
                    _post.likes.contains(FirebaseAuth.instance.currentUser!.uid) ? Icons.favorite : Icons.favorite_border,
                    color: postModel.likes.contains(FirebaseAuth.instance.currentUser!.uid) ? Colors.red : Colors.grey,
                  ),
                );
              }),
          SizedBox(width: 20),
          GestureDetector(
            onTap: () {
              navigateToNext(
                context,
                CommentScreen(
                  postId: postModel.postId,
                  postCreatorId: postModel.uid,
                ),
              );
            },
            child: SizedBox(
              height: 20,
              width: 20,
              child: Image.asset("assets/images/Comment.png"),
            ),
          ),
          SizedBox(width: 20),
          GestureDetector(
            onTap: () async {
              if (FirebaseAuth.instance.currentUser != null) {
                String postTitle = postModel.postTitle;
                String postImage = postModel.postImages[0];
                String shareText = '$postTitle\n$postImage';

                try {
                  await Share.share(shareText, subject: postTitle);
                } catch (e) {
                  print('Error sharing: $e');
                }
              } else {
                return;
              }
            },
            child: Icon(Icons.share, color: AppColors.primaryWhite),
          ),
          Spacer(),
          StreamBuilder<DocumentSnapshot>(
            stream: FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
              UserModel userModel = UserModel.fromDocumentSnapshot(snapshot.data!);
              return GestureDetector(
                onTap: () {
                  PostServices().savePost(userModel.bookMarks!, postModel.postId);
                },
                child: Icon(
                  userModel.bookMarks!.contains(postModel.postId) ? Icons.bookmark : Icons.bookmark_border,
                  size: 25,
                  color: AppColors.primaryWhite,
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
