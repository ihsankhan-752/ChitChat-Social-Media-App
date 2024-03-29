import 'dart:io';

import 'package:chitchat/providers/image_controller.dart';
import 'package:chitchat/providers/loading_controller.dart';
import 'package:chitchat/services/story_services.dart';
import 'package:chitchat/themes/colors.dart';
import 'package:chitchat/widgets/buttons.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../../../../widgets/text_input.dart';

class UploadStoryScreen extends StatefulWidget {
  const UploadStoryScreen({super.key});

  @override
  State<UploadStoryScreen> createState() => _UploadStoryScreenState();
}

class _UploadStoryScreenState extends State<UploadStoryScreen> {
  TextEditingController _storyTitleController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final imageController = Provider.of<ImageController>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Upload Story"),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Column(
          children: [
            SizedBox(height: 30),
            if (imageController.selectedImage == null)
              Container(
                height: MediaQuery.sizeOf(context).height * 0.25,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: AppColors.primaryColor, width: 2),
                ),
                child: Center(
                  child: GestureDetector(
                    onTap: () {
                      imageController.uploadImage(ImageSource.gallery);
                    },
                    child: Icon(Icons.image, size: 35, color: AppColors.primaryWhite),
                  ),
                ),
              )
            else
              Container(
                height: MediaQuery.sizeOf(context).height * 0.25,
                width: double.infinity,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: FileImage(File(imageController.selectedImage!.path)),
                    fit: BoxFit.cover,
                  ),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: AppColors.primaryColor, width: 2),
                ),
              ),
            SizedBox(height: 25),
            CustomTextInput(
              controller: _storyTitleController,
              hintText: "Title",
            ),
            SizedBox(height: 30),
            Consumer<LoadingController>(
              builder: (context, loadingController, child) {
                return loadingController.isLoading
                    ? Center(
                        child: CircularProgressIndicator(),
                      )
                    : PrimaryButton(
                        btnColor: AppColors.primaryColor,
                        title: "Upload",
                        onPressed: () {
                          StoryServices().uploadStory(
                            context: context,
                            storyImage: imageController.selectedImage!,
                            storyTitle: _storyTitleController.text.isEmpty ? "" : _storyTitleController.text,
                          );
                          setState(
                            () {
                              _storyTitleController.clear();
                              imageController.deleteUploadPhoto();
                            },
                          );
                        },
                      );
              },
            )
          ],
        ),
      ),
    );
  }
}
