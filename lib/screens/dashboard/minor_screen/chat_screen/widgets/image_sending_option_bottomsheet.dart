import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../../providers/image_controller.dart';
import '../../../../../themes/colors.dart';

imageSendingOptionBottomSheet(BuildContext context, ImageController imageController) {
  return SizedBox(
    height: 200,
    child: Column(
      children: [
        ListTile(
          onTap: () {
            imageController.uploadImage(ImageSource.gallery);
            Navigator.of(context).pop();
          },
          title: Text(
            "Upload From Gallery",
            style: TextStyle(color: AppColors.primaryWhite),
          ),
          trailing: Icon(Icons.photo, color: AppColors.primaryWhite),
        ),
        Divider(thickness: 1, color: AppColors.mainColor, height: 0.3),
        ListTile(
          onTap: () {
            imageController.uploadImage(ImageSource.camera);
            Navigator.of(context).pop();
          },
          title: Text(
            "Upload From Camera",
            style: TextStyle(color: AppColors.primaryWhite),
          ),
          trailing: Icon(Icons.camera, color: AppColors.primaryWhite),
        ),
        Divider(thickness: 1, color: AppColors.mainColor, height: 0.3),
        ListTile(
          onTap: () {
            Navigator.of(context).pop();
          },
          title: Text("Cancel", style: TextStyle(color: AppColors.primaryWhite)),
          trailing: Icon(Icons.cancel, color: AppColors.primaryWhite),
        )
      ],
    ),
  );
}
