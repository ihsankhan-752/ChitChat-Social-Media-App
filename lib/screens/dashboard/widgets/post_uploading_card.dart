import 'package:flutter/material.dart';

import '../../../themes/colors.dart';

class PostUploadingCard extends StatelessWidget {
  final Function()? onTappedForGallery;
  final Function()? onTapForCamera;
  const PostUploadingCard({Key? key, this.onTappedForGallery, this.onTapForCamera}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: IconButton(
          onPressed: () {
            showDialog(
                context: context,
                builder: (_) {
                  return SimpleDialog(
                    title: const Text("Create A Post"),
                    children: [
                      SimpleDialogOption(
                        onPressed: onTappedForGallery,
                        child: const Text("Gallery"),
                      ),
                      const Divider(),
                      SimpleDialogOption(
                        onPressed: onTapForCamera,
                        child: const Text("Camera"),
                      ),
                      const Divider(),
                      SimpleDialogOption(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: const Text("Cancel"),
                      ),
                    ],
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
    );
  }
}
