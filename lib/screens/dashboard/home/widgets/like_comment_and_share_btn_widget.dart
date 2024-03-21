import 'package:chitchat/models/post_model.dart';
import 'package:chitchat/services/post_services.dart';
import 'package:chitchat/themes/colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';

import '../../../../providers/post_controller.dart';
import '../../../../utils/screen_navigations.dart';
import '../../minor_screen/comment_screen/comment_screen.dart';

class LikeCommentShareButtonWidget extends StatelessWidget {
  final PostController postController;
  final String? postId;
  final int index;
  const LikeCommentShareButtonWidget({super.key, required this.postController, required this.index, this.postId});

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
                    PostServices().likeAndUnlikePost(_post, postId!);
                  },
                  child: Icon(
                    _post.likes.contains(FirebaseAuth.instance.currentUser!.uid) ? Icons.favorite : Icons.favorite_border,
                    color: postController.postList[index].likes.contains(FirebaseAuth.instance.currentUser!.uid)
                        ? Colors.red
                        : Colors.grey,
                  ),
                );
              }),
          SizedBox(width: 20),
          GestureDetector(
            onTap: () {
              navigateToNext(
                context,
                CommentScreen(
                  postId: postController.postList[index].postId,
                  postCreatorId: postController.postList[index].uid,
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
                String postTitle = postController.postList[index].postTitle;
                String postImage = postController.postList[index].postImages[0];
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
          Icon(Icons.bookmark_border, size: 25, color: AppColors.primaryWhite),
        ],
      ),
    );
  }
}
