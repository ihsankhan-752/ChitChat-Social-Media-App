import 'package:cached_network_image/cached_network_image.dart';
import 'package:chitchat/lib/providers/post_controller.dart';
import 'package:chitchat/lib/widgets/custom_alert_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../../../../themes/colors.dart';
import '../../../../utils/constants.dart';

class PostHeader extends StatelessWidget {
  final PostController postController;
  final int index;
  const PostHeader({super.key, required this.postController, required this.index});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Container(
        height: 45,
        width: 45,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: CachedNetworkImage(
            imageUrl: postController.postList[index].userImage,
            fit: BoxFit.cover,
            placeholder: (context, url) => spinKit2,
          ),
        ),
      ),
      title: Text(
        postController.postList[index].userName,
        style: GoogleFonts.poppins(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: AppColors.primaryWhite,
        ),
      ),
      subtitle: Text(
        timeago.format(postController.postList[index].createdAt),
        style: const TextStyle(
          fontSize: 12,
          color: Colors.grey,
        ),
      ),
      trailing: postController.postList[index].uid == FirebaseAuth.instance.currentUser!.uid
          ? InkWell(
              onTap: () {
                showCustomAlertDialog(
                  context: context,
                  content: "Are you Sure to Delete This Post?",
                  onPressed: () {
                    postController.deletePost(context: context, index: index);
                  },
                );
              },
              child: Icon(
                Icons.more_vert,
                color: AppColors.primaryWhite,
              ),
            )
          : const SizedBox(),
    );
  }
}
