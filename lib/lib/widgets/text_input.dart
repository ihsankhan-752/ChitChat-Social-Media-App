import 'package:flutter/material.dart';

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
