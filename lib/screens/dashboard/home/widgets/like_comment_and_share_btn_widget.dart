import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';

import '../../../../providers/post_controller.dart';
import '../../../../utils/screen_navigations.dart';
import '../../../../widgets/buttons.dart';
import '../../minor_screen/comment_screen/comment_screen.dart';

class LikeCommentShareButtonWidget extends StatelessWidget {
  final PostController postController;
  final int index;
  const LikeCommentShareButtonWidget(
      {super.key, required this.postController, required this.index});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CustomNeumorphicButton(
          title: "",
          icon: postController.postList[index].likes
                  .contains(FirebaseAuth.instance.currentUser!.uid)
              ? Icons.favorite
              : Icons.favorite_border,
          iconColor: postController.postList[index].likes
                  .contains(FirebaseAuth.instance.currentUser!.uid)
              ? Colors.red
              : Colors.grey,
          onPressed: () async {
            await postController.likeAndDislikePost(
              postCreatorId: postController.postList[index].uid,
              context: context,
              postId: postController.postList[index].postId,
            );
          },
        ),
        CustomNeumorphicButton(
          onPressed: () {
            navigateToNext(
                context,
                CommentScreen(
                  postId: postController.postList[index].postId,
                  postCreatorId: postController.postList[index].uid,
                ));
          },
          title: "",
          icon: Icons.comment,
          iconColor: Colors.grey,
        ),
        CustomNeumorphicButton(
          onPressed: () async {
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
          title: "",
          icon: Icons.share_outlined,
          iconColor: Colors.grey,
        )
      ],
    );
  }
}
