import 'package:cached_network_image/cached_network_image.dart';
import 'package:chitchat/providers/user_controller.dart';
import 'package:chitchat/services/user_profile_services.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../../../../consts/colors.dart';
import '../../../../providers/image_controller.dart';
import '../../../../widgets/loading_indicators.dart';
import '../../../../widgets/upload_photo_option_widget.dart';

class ImagePortion extends StatelessWidget {
  const ImagePortion({super.key});

  @override
  Widget build(BuildContext context) {
    final imageController = Provider.of<ImageController>(context);
    final userController = Provider.of<UserController>(context).userModel;
    return Container(
      height: 90,
      width: 90,
      child: Stack(
        children: [
          if (imageController.selectedImage == null && userController.imageUrl == "")
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: AppColors.primaryWhite),
              ),
              child: Center(
                child: Icon(Icons.person, size: 45, color: AppColors.primaryWhite),
              ),
            )
          else if (imageController.selectedImage == null && userController.imageUrl != "")
            Container(
              height: 80,
              width: 120,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: CachedNetworkImage(
                  imageUrl: userController.imageUrl!,
                  placeholder: (context, url) => spinKit2,
                  errorWidget: (context, url, error) => Icon(Icons.error),
                  fit: BoxFit.cover,
                ),
              ),
            )
          else
            Container(
              height: 80,
              width: 120,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                image: DecorationImage(
                  image: FileImage(imageController.selectedImage!),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          Positioned(
            bottom: 15,
            right: 3,
            child: Container(
              height: 25,
              width: 25,
              decoration: BoxDecoration(
                color: AppColors.primaryColor,
                borderRadius: BorderRadius.circular(8),
              ),
              child: InkWell(
                onTap: () {
                  if (imageController.selectedImage == null) {
                    uploadPhotoOptionWidget(
                      context: context,
                      onCameraClicked: () {
                        imageController.uploadImage(ImageSource.camera);
                        Navigator.pop(context);
                      },
                      onGalleryClicked: () {
                        imageController.uploadImage(ImageSource.gallery);
                        Navigator.pop(context);
                      },
                    );
                  } else {
                    UserProfileServices.updateProfilePic(
                      context,
                      imageController.selectedImage == null ? userController.imageUrl : imageController.selectedImage,
                    );
                    imageController.deleteUploadPhoto();
                  }
                },
                child: imageController.selectedImage == null
                    ? Icon(Icons.edit, size: 15, color: AppColors.primaryWhite)
                    : Icon(Icons.check, size: 15, color: AppColors.primaryWhite),
              ),
            ),
          )
        ],
      ),
    );
  }
}
