import 'package:chitchat/providers/loading_controller.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

import '../providers/user_controller.dart';
import '../themes/colors.dart';
import '../utils/text_styles.dart';

class TextInputField extends StatelessWidget {
  final String? hintText;
  final IconData? prefixIcon;
  final Widget? suffixChild;
  final TextInputType inputType;
  final bool isTextSecure;
  final TextEditingController? controller;
  const TextInputField({
    Key? key,
    this.hintText,
    this.isTextSecure = false,
    this.prefixIcon,
    this.suffixChild,
    this.inputType = TextInputType.text,
    this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 55,
      child: TextField(
        controller: controller,
        obscureText: isTextSecure,
        cursorColor: AppColors.primaryWhite,
        keyboardType: inputType,
        style: AppTextStyle.buttonTextStyle.copyWith(fontSize: 14),
        decoration: InputDecoration(
            hintText: hintText,
            hintStyle: const TextStyle(color: Colors.grey),
            prefixIcon: Icon(prefixIcon, color: Colors.grey, size: 20),
            suffixIcon: suffixChild,
            fillColor: AppColors.primaryColor,
            isDense: true,
            filled: true,
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            )),
      ),
    );
  }
}

class TextInputForSearch extends StatelessWidget {
  final TextEditingController? controller;
  final Function(String v)? onChanged;
  const TextInputForSearch({Key? key, this.controller, this.onChanged}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      style: TextStyle(
        color: AppColors.primaryWhite,
      ),
      controller: controller,
      // onFieldSubmitted: onFieldSubmitted,
      onChanged: onChanged,
      decoration: InputDecoration(
          fillColor: Colors.grey.withOpacity(0.2),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            // borderSide: BorderSide(color: AppColors.APP_CIRCULAR_RADIUS),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            // borderSide: BorderSide(color: AppColors.APP_CIRCULAR_RADIUS),
          ),
          filled: true,
          isDense: true,
          prefixIcon: Icon(Icons.search, color: AppColors.primaryWhite),
          hintText: "search",
          hintStyle: const TextStyle(
            color: Colors.white,
          )),
    );
  }
}

class CommentTextInput extends StatelessWidget {
  final TextEditingController? controller;
  final Function()? onPressed;

  const CommentTextInput({super.key, this.controller, this.onPressed});

  @override
  Widget build(BuildContext context) {
    final userController = Provider.of<UserController>(context);
    final loadingController = Provider.of<LoadingController>(context);
    return Container(
      height: 60,
      margin: EdgeInsets.only(top: 15, bottom: MediaQuery.of(context).viewInsets.bottom + 10, left: 10, right: 10),
      decoration: BoxDecoration(
        color: AppColors.primaryColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.only(left: 10, top: 5, right: 5, bottom: 5),
        child: Row(
          children: [
            CircleAvatar(
              radius: 15,
              backgroundImage: NetworkImage(userController.userModel.imageUrl!),
            ),
            const SizedBox(width: 10),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.65,
              child: TextField(
                controller: controller,
                style: const TextStyle(
                  color: Colors.grey,
                ),
                decoration: InputDecoration(
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.only(top: 0, bottom: 2),
                    hintText: "comment as ${userController.userModel.username}",
                    hintStyle: const TextStyle(
                      color: Colors.grey,
                    )),
              ),
            ),
            const SizedBox(width: 20),
            InkWell(
                onTap: onPressed,
                child: loadingController.isLoading
                    ? Center(child: CircularProgressIndicator(color: AppColors.btnColor))
                    : Icon(
                        FontAwesomeIcons.paperPlane,
                        color: AppColors.primaryWhite,
                      ))
          ],
        ),
      ),
    );
  }
}

class CustomTextInput extends StatelessWidget {
  final String hintText;
  final TextEditingController controller;
  const CustomTextInput({super.key, required this.hintText, required this.controller});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      style: TextStyle(
        color: AppColors.primaryWhite,
      ),
      decoration: InputDecoration(
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: AppColors.primaryColor, width: 2),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: AppColors.primaryColor, width: 2),
        ),
        hintText: "$hintText",
        hintStyle: TextStyle(
          color: AppColors.primaryWhite.withOpacity(0.3),
        ),
      ),
    );
  }
}

class CustomPasswordTextInput extends StatelessWidget {
  final String? Function(String? v)? validator;
  final String? hintText;
  final String? errorText;
  final TextEditingController? controller;
  const CustomPasswordTextInput({super.key, this.validator, this.hintText, this.errorText, this.controller});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextFormField(
        style: TextStyle(
          color: Colors.white.withOpacity(0.7),
        ),
        controller: controller,
        validator: validator,
        keyboardType: TextInputType.emailAddress,
        decoration: InputDecoration(
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: AppColors.primaryWhite.withOpacity(0.7)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: AppColors.primaryWhite.withOpacity(0.7)),
          ),
          hintStyle: TextStyle(
            fontWeight: FontWeight.normal,
            color: AppColors.primaryWhite.withOpacity(0.6),
          ),
          hintText: hintText!,
          // errorText: errorText ?? "",
        ),
      ),
    );
  }
}
