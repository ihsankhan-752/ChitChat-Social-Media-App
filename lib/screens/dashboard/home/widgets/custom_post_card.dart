import 'package:chitchat/providers/post_controller.dart';
import 'package:chitchat/screens/dashboard/home/widgets/post_footer.dart';
import 'package:chitchat/screens/dashboard/home/widgets/post_header.dart';
import 'package:chitchat/screens/dashboard/home/widgets/post_image_portion.dart';
import 'package:flutter/material.dart';

import '../../../../themes/colors.dart';
import '../../../../utils/custom_messanger.dart';
import '../../../../utils/screen_navigations.dart';
import 'like_comment_and_share_btn_widget.dart';
import 'list_of_user_who_like_post.dart';

class CustomPostCard extends StatelessWidget {
  final PostController postController;
  final int index;
  const CustomPostCard({super.key, required this.postController, required this.index});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 15, left: 10, right: 10),
      elevation: 32,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(color: AppColors.primaryColor, width: 3),
      ),
      color: AppColors.primaryBlack,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          PostHeader(
            postController: postController,
            index: index,
          ),
          PostImagePortion(
            postController: postController,
            index: index,
          ),
          LikeCommentShareButtonWidget(
            postId: postController.postList[index].postId,
            postController: postController,
            index: index,
          ),
          SizedBox(height: 15),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: InkWell(
              onTap: () {
                if (postController.postList[index].likes.isEmpty) {
                  showMessage(context, "No One Like This Post");
                } else {
                  navigateToNext(context, ListOfUsersWhoLikePost(likes: postController.postList[index].likes));
                }
              },
              child: Text(
                "${postController.postList[index].likes.length}  likes",
                style: TextStyle(
                  color: AppColors.primaryWhite,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),
          Divider(color: AppColors.primaryColor, height: 0.1, thickness: 1),
          PostFooter(postController: postController, index: index),
          const SizedBox(height: 10),
        ],
      ),
    );
  }
}
