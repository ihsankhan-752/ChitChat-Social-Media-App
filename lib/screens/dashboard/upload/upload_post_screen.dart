// ignore_for_file: use_build_context_synchronously
import 'package:chitchat/screens/dashboard/upload/widgets/post_image_uploading_widget.dart';
import 'package:chitchat/screens/dashboard/upload/widgets/post_video_uploading_widget.dart';
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
    final fileController = Provider.of<FileController>(context);
    final imageController = Provider.of<ImageController>(context);
    return currentIndex == 0
        ? imageController.imageFileList!.isEmpty
            ? Scaffold(
                body: Center(
                  child: IconButton(
                    onPressed: () {
                      showModalBottomSheet(
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(15),
                                topRight: Radius.circular(15)),
                          ),
                          context: context,
                          builder: (_) {
                            return SizedBox(
                              height: 200,
                              child: Column(
                                children: [
                                  ListTile(
                                    onTap: () {
                                      imageController.uploadPostImages();
                                      Navigator.of(context).pop();
                                      setState(() {
                                        currentIndex = 0;
                                      });
                                    },
                                    title: const Text("Upload From Gallery"),
                                    trailing: const Icon(Icons.photo),
                                  ),
                                  Divider(
                                      thickness: 1,
                                      color: AppColors.primaryGrey),
                                  ListTile(
                                    onTap: () {
                                      setState(() {
                                        currentIndex = 1;
                                      });
                                      Navigator.of(context).pop();
                                      fileController.selectFile();
                                    },
                                    title: const Text("Upload Video"),
                                    trailing: const Icon(Icons.video_call),
                                  ),
                                  Divider(
                                      thickness: 1,
                                      color: AppColors.primaryGrey),
                                  ListTile(
                                    onTap: () {
                                      Navigator.of(context).pop();
                                    },
                                    title: const Text("Cancel"),
                                    trailing: const Icon(Icons.cancel),
                                  )
                                ],
                              ),
                            );
                          });
                    },
                    icon: Icon(
                      Icons.upload,
                      size: 25,
                      color: AppColors.primaryWhite,
                    ),
                  ),
                ),
              )
            : const PostImageUploadingWidget()
        : const PostVideoUploadingWidget();
  }
}
