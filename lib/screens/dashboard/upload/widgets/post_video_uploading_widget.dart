import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../dummy_screen.dart';
import '../../../../providers/file_controller.dart';
import '../../../../providers/loading_controller.dart';
import '../../../../providers/post_controller.dart';
import '../../../../providers/user_controller.dart';
import '../../../../themes/colors.dart';
import '../../../../utils/screen_navigations.dart';
import '../../bottom_nav_bar.dart';

class PostVideoUploadingWidget extends StatefulWidget {
  const PostVideoUploadingWidget({super.key});

  @override
  State<PostVideoUploadingWidget> createState() =>
      _PostVideoUploadingWidgetState();
}

class _PostVideoUploadingWidgetState extends State<PostVideoUploadingWidget> {
  TextEditingController postController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final fileController = Provider.of<FileController>(context);
    final loadingController = Provider.of<LoadingController>(context);
    final userController = Provider.of<UserController>(context);
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: IconButton(
          icon: Icon(Icons.close, color: AppColors.primaryWhite),
          onPressed: () {
            fileController.removeUploadVideoUrl();
            navigateToNext(context, const BottomNavBar());
          },
        ),
        actions: [
          Center(
            child: Text(
              "Post To",
              style: TextStyle(
                color: AppColors.skyColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(width: 20),
          IconButton(
              onPressed: () async {
                await PostController().uploadVideoInPost(
                  context: context,
                  videoUrl: fileController.pickedFile!,
                  postMsg: postController.text,
                );
                fileController.removeUploadVideoUrl();
              },
              icon: const Icon(Icons.arrow_forward),
              color: AppColors.primaryWhite),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            loadingController.isLoading
                ? Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: LinearProgressIndicator(
                        color: AppColors.appCircularRadius),
                  )
                : const SizedBox(),
            fileController.pickedFile == null
                ? const SizedBox(
                    height: 200,
                    child: Center(
                      child: Text("No File Selected"),
                    ),
                  )
                : Column(
                    children: [
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.4,
                        child: Center(
                          child: VideoPlayerWidget(
                            path: File(fileController.pickedFile!.path),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 25,
                            backgroundImage: NetworkImage(
                                userController.userModel.imageUrl!),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: SizedBox(
                              width: MediaQuery.of(context).size.width * 0.8,
                              child: TextField(
                                controller: postController,
                                decoration: const InputDecoration(
                                  filled: true,
                                  fillColor: Colors.grey,
                                  hintText: "Add Caption",
                                ),
                              ),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
