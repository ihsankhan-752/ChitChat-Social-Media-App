import 'package:flutter/material.dart';

import '../../../consts/colors.dart';

class MessageTextInput extends StatelessWidget {
  final TextEditingController? controller;
  final Widget? sendingTextBtn;
  final Function()? picSelectionTapped;
  const MessageTextInput({Key? key, this.controller, this.sendingTextBtn, this.picSelectionTapped}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 12, right: 8, bottom: MediaQuery.of(context).viewInsets.bottom + 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: TextField(
              controller: controller,
              style: TextStyle(
                color: AppColors.primaryWhite,
              ),
              decoration: InputDecoration(
                  fillColor: AppColors.primaryColor,
                  filled: true,
                  isDense: true,
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  border: InputBorder.none,
                  hintText: "Message....",
                  hintStyle: const TextStyle(
                    color: Colors.grey,
                  )),
            ),
          ),
          SizedBox(width: 10),
          sendingTextBtn!,
        ],
      ),
    );
  }
}
