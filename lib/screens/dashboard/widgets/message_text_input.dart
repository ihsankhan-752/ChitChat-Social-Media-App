import 'package:flutter/material.dart';

import '../../../themes/colors.dart';

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
            child: Container(
              height: 60,
              decoration: BoxDecoration(
                color: AppColors.primaryColor,
                borderRadius: BorderRadius.circular(15),
              ),
              child: TextField(
                controller: controller,
                style: TextStyle(
                  color: AppColors.primaryWhite,
                ),
                decoration: InputDecoration(
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.only(top: 20),
                    prefixIcon: IconButton(
                      onPressed: picSelectionTapped,
                      icon: Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: Icon(Icons.photo, color: AppColors.primaryWhite),
                      ),
                    ),
                    hintText: "Message....",
                    hintStyle: const TextStyle(
                      color: Colors.grey,
                    )),
              ),
            ),
          ),
          SizedBox(width: 10),
          sendingTextBtn!,
        ],
      ),
    );
  }
}
