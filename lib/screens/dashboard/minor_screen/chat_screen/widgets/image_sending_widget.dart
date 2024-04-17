import 'dart:io';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

import '../../../../../providers/image_controller.dart';
import '../../../../../providers/loading_controller.dart';
import '../../../../../services/chat_services.dart';
import '../../../../../services/firebase_storage_services.dart';
import '../../../../../themes/colors.dart';

class ImageSendingWidget extends StatelessWidget {
  final ImageController imageController;
  final String userId, docId;
  const ImageSendingWidget({super.key, required this.imageController, required this.userId, required this.docId});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          height: MediaQuery.of(context).size.height * 0.8,
          width: double.infinity,
          color: Colors.red,
          child: ColorFiltered(
            colorFilter: ColorFilter.mode(AppColors.primaryBlack.withOpacity(0.5), BlendMode.srcATop),
            child: Image.file(File(imageController.selectedImage!.path), fit: BoxFit.cover),
          ),
        ),
        Positioned(
          bottom: 10,
          right: 10,
          child: Consumer<LoadingController>(
            builder: (context, loadingController, child) {
              return loadingController.isLoading
                  ? Container(
                      height: 45,
                      width: 45,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.primaryWhite,
                      ),
                      child: Center(
                        child: Padding(
                          padding: EdgeInsets.all(5),
                          child: CircularProgressIndicator(color: AppColors.primaryBlack),
                        ),
                      ),
                    )
                  : InkWell(
                      onTap: () async {
                        String imageUrl = await StorageServices().uploadPhoto(imageController.selectedImage);
                        await ChatServices()
                            .sendMsg(
                          context: context,
                          imageUrl: imageUrl,
                          userId: userId,
                          msg: "",
                          docId: docId,
                        )
                            .then((value) {
                          imageController.deleteUploadPhoto();
                        });
                      },
                      child: Container(
                        height: 45,
                        width: 45,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.primaryWhite,
                        ),
                        child: Center(
                          child: Icon(FontAwesomeIcons.paperPlane, size: 20, color: AppColors.primaryBlack),
                        ),
                      ),
                    );
            },
          ),
        )
      ],
    );
  }
}
