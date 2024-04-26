// ignore_for_file: use_build_context_synchronously
import 'dart:io';

import 'package:chitchat/consts/text_styles.dart';
import 'package:chitchat/providers/loading_controller.dart';
import 'package:chitchat/widgets/buttons.dart';
import 'package:chitchat/widgets/custom_messanger.dart';
import 'package:chitchat/widgets/text_input.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../consts/colors.dart';
import '../../../providers/image_controller.dart';
import '../../../services/post_services.dart';
import '../../../widgets/loading_indicators.dart';

class AddPostScreen extends StatefulWidget {
  const AddPostScreen({Key? key}) : super(key: key);

  @override
  State<AddPostScreen> createState() => _AddPostScreenState();
}

class _AddPostScreenState extends State<AddPostScreen> {
  String? url;
  int currentIndex = 0;
  TextEditingController postController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final imageController = Provider.of<ImageController>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Upload Post"),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            imageController.imageFileList!.isEmpty
                ? Container(
                    height: 150,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: AppColors.primaryColor, width: 2),
                    ),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconButton(
                            onPressed: () {
                              imageController.uploadPostImages();
                            },
                            icon: Icon(Icons.cloud_upload_outlined, color: AppColors.primaryWhite, size: 35),
                          ),
                          SizedBox(height: 10),
                          Text(
                            "Post single or multiple\nImages",
                            textAlign: TextAlign.center,
                            style: AppTextStyle.mainHeading.copyWith(
                              fontSize: 12,
                            ),
                          )
                        ],
                      ),
                    ),
                  )
                : Container(
                    height: 150,
                    width: double.infinity,
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
                            child: Stack(
                              children: [
                                Image.file(
                                  File(imageController.imageFileList![index].path),
                                  fit: BoxFit.cover,
                                ),
                                Positioned(
                                  top: 10,
                                  right: 10,
                                  child: GestureDetector(
                                    onTap: () {
                                      imageController.imageFileList!.removeAt(index);
                                      setState(() {});
                                    },
                                    child: Icon(Icons.delete_forever, color: Colors.red),
                                  ),
                                )
                              ],
                            ),
                          ),
                        );
                      },
                    )),
            SizedBox(height: 30),
            Text("Post Description", style: AppTextStyle.mainHeading.copyWith(fontSize: 13)),
            SizedBox(height: 10),
            CustomTextInput(
              hintText: 'write something....',
              controller: postController,
              maxLines: 4,
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
        child: Consumer<LoadingController>(builder: (context, loadingController, child) {
          return loadingController.isLoading
              ? Container(
                  height: 50,
                  width: 100,
                  child: spinKit2,
                )
              : PrimaryButton(
                  onPressed: () async {
                    if (imageController.imageFileList!.isEmpty || postController.text.isEmpty) {
                      showMessage(context, "Please Upload Photo and write something");
                    } else {
                      await PostServices().uploadPostImages(
                        context: context,
                        imageFileList: imageController.imageFileList!,
                        postMsg: postController.text,
                      );
                      imageController.clearPostImages();
                    }
                  },
                  btnColor: AppColors.primaryColor,
                  title: "Post",
                );
        }),
      ),
    );
  }
}
