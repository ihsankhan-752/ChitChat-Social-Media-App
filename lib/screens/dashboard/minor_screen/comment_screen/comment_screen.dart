import 'package:chitchat/providers/comment_controller.dart';
import 'package:chitchat/widgets/text_input.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../services/comment_services.dart';
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
  TextEditingController commentTextController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadComments();
  }

  _loadComments() async {
    await Provider.of<CommentController>(context, listen: false).getAllComments(widget.postId!);
  }

  @override
  Widget build(BuildContext context) {
    final commentController = Provider.of<CommentController>(context).commentModel;
    return Scaffold(
      bottomNavigationBar: CommentTextInput(
        controller: commentTextController,
        onPressed: () {
          CommentServices().addingComment(
            context: context,
            comment: commentTextController.text,
            postId: widget.postId!,
            postCreatorId: widget.postCreatorId,
          );
          setState(() {
            commentController.clear();
            FocusScope.of(context).unfocus();
          });
        },
      ),
      appBar: AppBar(
        title: Text("Comments"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            commentController.isEmpty
                ? Padding(
                    padding: EdgeInsets.only(top: MediaQuery.sizeOf(context).height * 0.35),
                    child: Center(
                      child: Text(
                        "No One Comment on This Post Yet",
                        style: TextStyle(
                          color: AppColors.primaryWhite,
                          fontSize: 18,
                        ),
                      ),
                    ),
                  )
                : SizedBox(
                    height: MediaQuery.sizeOf(context).height * 0.75,
                    child: ListView.builder(
                      itemCount: commentController.length,
                      itemBuilder: (context, index) {
                        return CommentSnapCard(
                          commentModel: commentController[index],
                        );
                      },
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
