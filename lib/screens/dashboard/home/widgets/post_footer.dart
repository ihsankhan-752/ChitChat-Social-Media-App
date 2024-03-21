import 'package:flutter/material.dart';

import '../../../../providers/post_controller.dart';

class PostFooter extends StatelessWidget {
  final PostController postController;
  final int index;
  const PostFooter({super.key, required this.postController, required this.index});

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.sizeOf(context).width * 1;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
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
        ],
      ),
    );
  }
}
