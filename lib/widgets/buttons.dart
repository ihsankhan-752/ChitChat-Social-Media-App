import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:neumorphic_button/neumorphic_button.dart';

import '../themes/colors.dart';
import '../utils/text_styles.dart';

class PrimaryButton extends StatelessWidget {
  final String? title;
  final Function()? onPressed;
  final IconData? icon;
  final bool isIconReq;
  final Color? btnColor;
  final Color? iconColor;
  const PrimaryButton({
    Key? key,
    this.title,
    this.onPressed,
    this.icon,
    this.isIconReq = false,
    this.btnColor,
    this.iconColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed ?? () {},
      child: Container(
        height: 55,
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: btnColor,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            isIconReq ? Icon(icon, color: iconColor) : const SizedBox(),
            isIconReq ? const SizedBox(width: 15) : const SizedBox(width: 0),
            Text(
              title!,
              style: AppTextStyle.buttonTextStyle,
            )
          ],
        ),
      ),
    );
  }
}

class SocialLoginButton extends StatelessWidget {
  final IconData? icon;
  final Color? iconColor;
  const SocialLoginButton({Key? key, this.icon, this.iconColor}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10),
      height: 60,
      width: 80,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: AppColors.primaryGrey,
      ),
      child: Center(
        child: Icon(icon, color: iconColor),
      ),
    );
  }
}

class ProfileScreenMainButton extends StatelessWidget {
  final Color? btnColor;
  final Color? borderColor;
  final Function()? onPressed;
  final String? title;
  const ProfileScreenMainButton({Key? key, this.btnColor, this.borderColor, this.onPressed, this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      highlightColor: Colors.transparent,
      child: Container(
        height: 35,
        width: 100,
        decoration:
            BoxDecoration(borderRadius: BorderRadius.circular(08), color: btnColor, border: Border.all(color: borderColor!)),
        child: Center(
          child: Text(
            title!,
            style: TextStyle(
              color: AppColors.primaryWhite,
            ),
          ),
        ),
      ),
    );
  }
}

class CustomNeumorphicButton extends StatelessWidget {
  final String? title;
  final Color? iconColor;
  final IconData icon;
  final Function()? onPressed;
  const CustomNeumorphicButton({super.key, this.title, required this.icon, this.iconColor, this.onPressed});

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.sizeOf(context).width * 1;
    return NeumorphicButton(
      onTap: onPressed ?? () {},
      bottomRightShadowBlurRadius: 5,
      bottomRightShadowSpreadRadius: 1,
      borderWidth: 1,
      backgroundColor: Colors.black,
      topLeftShadowBlurRadius: 5,
      topLeftShadowSpreadRadius: 1,
      topLeftShadowColor: Colors.grey.shade800,
      bottomRightShadowColor: Colors.grey.shade900,
      height: width * 0.1,
      width: width * 0.14,
      padding: const EdgeInsets.all(10),
      bottomRightOffset: const Offset(-1, -1),
      topLeftOffset: const Offset(0, 0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 10),
          Icon(icon, color: iconColor!, size: 20),
          Padding(
            padding: title == "" ? const EdgeInsets.only(top: 0) : const EdgeInsets.only(top: 1),
            child: Text(
              title ?? "",
              style: TextStyle(
                color: AppColors.primaryWhite,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ProfileScreenButton extends StatelessWidget {
  final Function() onPressed;
  final Color? btnColor;
  final String? title;
  final String? subTitle;
  final Color? titleColor;
  final Color? subTitleColor;

  const ProfileScreenButton(
      {super.key, required this.onPressed, this.btnColor, this.title, this.subTitle, this.titleColor, this.subTitleColor});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      onTap: onPressed,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 02, horizontal: 2),
        height: 50,
        width: 100,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: btnColor,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              title!,
              style: TextStyle(
                color: titleColor!,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              subTitle!,
              style: TextStyle(
                color: subTitleColor,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class TextSendingButton extends StatelessWidget {
  final VoidCallback? onPressed;
  const TextSendingButton({super.key, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        height: 60,
        width: 60,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: AppColors.primaryColor,
        ),
        child: Icon(FontAwesomeIcons.paperPlane, color: AppColors.primaryWhite, size: 20),
      ),
    );
  }
}
