import 'package:flutter/material.dart';

import '../../../../providers/post_controller.dart';
import '../../../../utils/custom_messanger.dart';
import '../../../../utils/screen_navigations.dart';
import 'list_of_user_who_like_post.dart';

class PostFooter extends StatelessWidget {
  final PostController postController;
  final int index;
  const PostFooter(
      {super.key, required this.postController, required this.index});

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.sizeOf(context).width * 1;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(
            width: width * 0.7,
            child: Text(
              postController.postList[index].postTitle,
              style: const TextStyle(
                color: Colors.white,
              ),
            ),
          ),
          InkWell(
            onTap: () {
              if (postController.postList[index].likes.isEmpty) {
                showMessage(context, "No One Like This Post");
              } else {
                navigateToNext(
                    context,
                    ListOfUsersWhoLikePost(
                        likes: postController.postList[index].likes));
              }
            },
            child: SizedBox(
              width: width * 0.2,
              child: Text(
                "Likes : ${postController.postList[index].likes.length}",
                style: const TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
