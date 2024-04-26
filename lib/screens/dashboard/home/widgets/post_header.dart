import 'package:cached_network_image/cached_network_image.dart';
import 'package:chitchat/consts/screen_navigations.dart';
import 'package:chitchat/models/post_model.dart';
import 'package:chitchat/screens/dashboard/minor_screen/report_screen/report_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../../../../consts/colors.dart';
import '../../../../widgets/custom_alert_dialog.dart';
import '../../../../widgets/loading_indicators.dart';

class PostHeader extends StatefulWidget {
  final PostModel postModel;
  const PostHeader({super.key, required this.postModel});

  @override
  State<PostHeader> createState() => _PostHeaderState();
}

class _PostHeaderState extends State<PostHeader> {
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
            imageUrl: widget.postModel.userImage,
            fit: BoxFit.cover,
            placeholder: (context, url) => spinKit2,
          ),
        ),
      ),
      title: Text(
        widget.postModel.userName,
        style: GoogleFonts.poppins(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: AppColors.primaryWhite,
        ),
      ),
      subtitle: Text(
        timeago.format(widget.postModel.createdAt),
        style: const TextStyle(
          fontSize: 12,
          color: Colors.grey,
        ),
      ),
      trailing: widget.postModel.uid == FirebaseAuth.instance.currentUser!.uid
          ? InkWell(
              onTap: () {
                showCustomAlertDialog(
                  context: context,
                  content: "Are you Sure to Delete This Post?",
                  onPressed: () async {
                    try {
                      await FirebaseFirestore.instance.collection('posts').doc(widget.postModel.postId).delete();
                      Navigator.pop(context);
                      setState(() {});
                    } catch (error) {
                      print("Error deleting post: $error");
                    }
                  },
                );
              },
              child: Icon(
                Icons.more_vert,
                color: AppColors.primaryWhite,
              ),
            )
          : PopupMenuButton(
              icon: Icon(Icons.more_vert, color: AppColors.primaryWhite),
              onSelected: (v) {
                if (v == 'report') {
                  navigateToNext(context, ReportScreen(postId: widget.postModel.postId));
                }
              },
              itemBuilder: (context) => <PopupMenuEntry<String>>[
                PopupMenuItem<String>(
                  value: 'report',
                  child: Row(
                    children: [
                      Icon(
                        Icons.report,
                        color: Colors.red,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Report',
                        style: TextStyle(
                          color: Colors.red,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}
