// ignore_for_file: use_build_context_synchronously

import 'package:chitchat/lib/models/comment_model.dart';
import 'package:chitchat/lib/providers/loading_controller.dart';
import 'package:chitchat/lib/providers/user_controller.dart';
import 'package:chitchat/lib/services/comment_services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

import '../../../../themes/colors.dart';
import '../../widgets/comment_snap_card.dart';

class CommentScreen extends StatefulWidget {
  final String? postId;
  final String postCreatorId;
  const CommentScreen({Key? key, this.postId, required this.postCreatorId}) : super(key: key);

  @override
  State<CommentScreen> createState() => _CommentScreenState();
}

class _CommentScreenState extends State<CommentScreen> {
  TextEditingController commentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final userController = Provider.of<UserController>(context);
    final loadingController = Provider.of<LoadingController>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Comments"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.75,
              child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection("posts")
                    .doc(widget.postId)
                    .collection("comments")
                    .orderBy("createdAt", descending: true)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (snapshot.data!.docs.isEmpty) {
                    return Center(
                      child: Text(
                        "No One Comment This Post Yet",
                        style: TextStyle(
                          color: AppColors.primaryWhite,
                        ),
                      ),
                    );
                  }
                  return ListView.builder(
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      CommentModel commentModel = CommentModel.fromDoc(snapshot.data!.docs[index]);
                      return CommentSnapCard(
                        commentModel: commentModel,
                      );
                    },
                  );
                },
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 15),
              decoration: BoxDecoration(
                color: AppColors.primaryColor,
                border: Border.all(color: AppColors.primaryWhite),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Padding(
                padding: const EdgeInsets.only(left: 05, top: 5, right: 5, bottom: 5),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 25,
                      backgroundImage: NetworkImage(userController.userModel.imageUrl!),
                    ),
                    const SizedBox(width: 10),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.65,
                      child: TextField(
                        controller: commentController,
                        style: const TextStyle(
                          color: Colors.grey,
                        ),
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            contentPadding: const EdgeInsets.only(top: 5),
                            hintText: "comment as ${userController.userModel.username}",
                            hintStyle: const TextStyle(
                              color: Colors.grey,
                            )),
                      ),
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      child: InkWell(
                          onTap: () async {
                            await CommentServices().addingComment(
                              context: context,
                              comment: commentController.text,
                              postId: widget.postId!,
                              postCreatorId: widget.postCreatorId,
                            );
                            setState(() {
                              commentController.clear();
                              FocusScope.of(context).unfocus();
                            });
                          },
                          child: loadingController.isLoading
                              ? Center(child: CircularProgressIndicator(color: AppColors.btnColor))
                              : Icon(
                                  FontAwesomeIcons.paperPlane,
                                  color: AppColors.skyColor,
                                )),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
