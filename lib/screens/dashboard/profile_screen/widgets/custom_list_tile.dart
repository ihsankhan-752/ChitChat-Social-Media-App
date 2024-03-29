import 'package:flutter/material.dart';

import '../../../../themes/colors.dart';
import '../../../../utils/text_styles.dart';

class CustomListTile extends StatelessWidget {
  final String title;
  final IconData? icon;
  final Function()? onPressed;
  final bool? isImage;
  final String? image;
  const CustomListTile({super.key, required this.title, this.icon, this.onPressed, this.isImage, this.image});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onPressed ?? () {},
      leading: isImage == true
          ? SizedBox(
              height: 20,
              width: 20,
              child: Image.asset(image!, color: AppColors.primaryColor),
            )
          : Icon(icon, size: 20, color: AppColors.primaryColor),
      title: Text(
        title,
        style: AppTextStyle.mainHeading.copyWith(
          fontSize: 16,
          color: AppColors.primaryColor,
        ),
      ),
    );
  }
}
