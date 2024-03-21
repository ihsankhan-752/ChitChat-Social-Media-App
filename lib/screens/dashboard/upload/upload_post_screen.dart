// ignore_for_file: use_build_context_synchronously
import 'package:chitchat/screens/dashboard/upload/widgets/post_image_uploading_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../providers/file_controller.dart';
import '../../../providers/image_controller.dart';
import '../../../themes/colors.dart';

class AddPostScreen extends StatefulWidget {
  const AddPostScreen({Key? key}) : super(key: key);

  @override
  State<AddPostScreen> createState() => _AddPostScreenState();
}

class _AddPostScreenState extends State<AddPostScreen> {
  String? url;
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final imageController = Provider.of<ImageController>(context);
    return imageController.imageFileList!.isEmpty
        ? Scaffold(
            body: Center(
              child: IconButton(
                onPressed: () {
                  imageController.uploadPostImages();
                },
                icon: Icon(
                  Icons.upload,
                  size: 25,
                  color: AppColors.primaryWhite,
                ),
              ),
            ),
          )
        : const PostImageUploadingWidget();
  }
}
