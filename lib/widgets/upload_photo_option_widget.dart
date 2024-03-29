import 'package:flutter/material.dart';

import '../screens/dashboard/profile_screen/widgets/custom_list_tile.dart';
import '../themes/colors.dart';

uploadPhotoOptionWidget({BuildContext? context, Function()? onCameraClicked, Function()? onGalleryClicked}) {
  return showModalBottomSheet(
    backgroundColor: AppColors.primaryWhite,
    context: context!,
    builder: (_) {
      return Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("Select Source",
                style: TextStyle(
                  color: AppColors.primaryBlack,
                  fontSize: 22,
                )),
            SizedBox(height: 20),
            CustomListTile(
              onPressed: onCameraClicked,
              icon: Icons.camera_alt_outlined,
              title: "Camera",
            ),
            SizedBox(height: 10),
            CustomListTile(
              onPressed: onGalleryClicked,
              icon: Icons.photo,
              title: "From Gallery",
            ),
            SizedBox(height: 10),
            CustomListTile(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icons.cancel_outlined,
              title: "Cancel",
            ),
            SizedBox(height: 20),
          ],
        ),
      );
    },
  );
}
