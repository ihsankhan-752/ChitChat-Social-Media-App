// ignore_for_file: use_build_context_synchronously

import 'package:chitchat/lib/models/comment_model.dart';
import 'package:chitchat/lib/services/comment_services.dart';
import 'package:chitchat/lib/themes/colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:uuid/uuid.dart';

import '../minor_screen/comment_screen/widgets/display_all_reply_widget.dart';
import '../minor_screen/comment_screen/widgets/reply_adding_widget.dart';

class CommentSnapCard extends StatefulWidget {
  final CommentModel commentModel;
  const CommentSnapCard({Key? key, required this.commentModel}) : super(key: key);

  @override
  State<CommentSnapCard> createState() => _CommentSnapCardState();
}

class _CommentSnapCardState extends State<CommentSnapCard> {
  bool isShowReply = false;
  TextEditingController replyController = TextEditingController();
  bool isDisplay = false;
  final replyId = const Uuid().v1();
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 12,
      color: AppColors.primaryColor,
      child: Column(
        children: [
          const SizedBox(height: 05),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 15,
                  backgroundImage: NetworkImage(widget.commentModel.userImage),
                ),
                const SizedBox(width: 20),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.7,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        widget.commentModel.username,
                        style: GoogleFonts.poppins(
                          color: AppColors.primaryWhite,
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                      Text(
                        widget.commentModel.comment,
                        style: GoogleFonts.poppins(
                          color: AppColors.primaryWhite,
                          fontSize: 13,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Row(
                        children: [
                          Text(
                            (timeago.format(widget.commentModel.createdAt)),
                            style: const TextStyle(
                              fontSize: 13,
                              color: Colors.grey,
                            ),
                          ),
                          const SizedBox(width: 20),
                          Text(
                            "${widget.commentModel.likes.length} likes",
                            style: const TextStyle(
                              fontSize: 13,
                              color: Colors.grey,
                            ),
                          ),
                          const SizedBox(width: 20),
                          ReplyAddingWidget(
                              controller: replyController,
                              onPressed: () async {
                                await CommentServices().replyOnComment(
                                  context: context,
                                  postId: widget.commentModel.postId,
                                  commentId: widget.commentModel.commentId,
                                  replyMsg: replyController.text,
                                );
                                setState(() {
                                  Navigator.pop(context);
                                  replyController.clear();
                                });
                              })
                        ],
                      ),
                      const SizedBox(height: 08),
                      DisplayAllReplayWidget(
                        postId: widget.commentModel.postId,
                        commentId: widget.commentModel.commentId,
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                Container(
                  width: 20,
                  height: 20,
                  margin: const EdgeInsets.only(right: 5),
                  child: IconButton(
                    icon: widget.commentModel.likes.contains(FirebaseAuth.instance.currentUser!.uid)
                        ? const Icon(Icons.favorite, color: Colors.red, size: 15)
                        : const Icon(Icons.favorite_border, color: Colors.grey, size: 15),
                    onPressed: () async {
                      String commentId = widget.commentModel.commentId;
                      await CommentServices()
                          .likeComment(context, widget.commentModel.postId, commentId, widget.commentModel.likes);
                    },
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
