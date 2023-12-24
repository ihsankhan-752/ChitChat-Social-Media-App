import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../providers/image_controller.dart';
import '../../../../providers/loading_controller.dart';
import '../../../../providers/post_controller.dart';
import '../../../../providers/user_controller.dart';
import '../../../../themes/colors.dart';

class PostImageUploadingWidget extends StatefulWidget {
  const PostImageUploadingWidget({super.key});

  @override
  State<PostImageUploadingWidget> createState() =>
      _PostImageUploadingWidgetState();
}

class _PostImageUploadingWidgetState extends State<PostImageUploadingWidget> {
  TextEditingController postController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final imageController = Provider.of<ImageController>(context);
    final loadingController = Provider.of<LoadingController>(context);
    final userController = Provider.of<UserController>(context);
    return Scaffold(
      appBar: AppBar(
        leading: Icon(Icons.arrow_back, color: AppColors.primaryWhite),
        title: const Text("Post to"),
        actions: [
          InkWell(
            onTap: () async {
              await PostController().uploadPostImages(
                context: context,
                imageFileList: imageController.imageFileList!,
                postMsg: postController.text,
              );
              imageController.clearPostImages();
            },
            child: Center(
              child: Padding(
                padding: const EdgeInsets.only(right: 15),
                child: Text(
                  "Post",
                  style: TextStyle(
                    fontSize: 18,
                    color: AppColors.skyColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          )
        ],
      ),
      body: Column(
        children: [
          loadingController.isLoading
              ? LinearProgressIndicator(
                  color: AppColors.appCircularRadius,
                )
              : const SizedBox(),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              CircleAvatar(
                radius: 25,
                backgroundImage:
                    NetworkImage(userController.userModel.imageUrl!),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.6,
                child: TextField(
                  controller: postController,
                  style: const TextStyle(color: Colors.grey),
                  decoration: const InputDecoration(
                    hintText: "write a post",
                    hintStyle: TextStyle(color: Colors.grey),
                  ),
                ),
              ),
              Container(
                  height: 100,
                  width: 80,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: imageController.imageFileList!.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.file(
                            File(imageController.imageFileList![index].path),
                            fit: BoxFit.cover,
                          ),
                        ),
                      );
                    },
                  ))
            ],
          )
        ],
      ),
    );
  }
}
