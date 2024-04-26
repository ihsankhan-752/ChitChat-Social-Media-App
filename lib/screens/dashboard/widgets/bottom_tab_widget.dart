import 'package:flutter/material.dart';

class BottomTabWidget extends StatelessWidget {
  final String? image;
  final Function()? onPressed;
  final Color? imageColor;
  const BottomTabWidget({super.key, this.image, this.onPressed, this.imageColor});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed ?? () {},
      child: SizedBox(
        height: 22,
        width: 25,
        child: Image.asset(image!, color: imageColor!),
      ),
    );
  }
}
