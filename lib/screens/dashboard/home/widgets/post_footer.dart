import 'package:chitchat/models/post_model.dart';
import 'package:flutter/material.dart';

class PostFooter extends StatelessWidget {
  final PostModel postModel;
  const PostFooter({super.key, required this.postModel});

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
              postModel.postTitle,
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
